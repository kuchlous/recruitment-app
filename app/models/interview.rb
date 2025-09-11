class Interview < ActiveRecord::Base
  #uncomment later
  # belongs_to :requirement
  belongs_to :req_match
  belongs_to :employee
  has_many :feedbacks, dependent: :destroy

  validates_presence_of :employee_id
  validates_presence_of :interview_date
  #uncomment later
  validate :overlapping_interviews
  validate :date_should_not_be_less_than_current_date
  scope :next_week, -> { where("interview_date >= ? AND interview_date <= ?", Date.today,Date.today+1.week).count }

  # Calendar integration
  after_create :add_to_calendar, if: :should_add_to_calendar? && :is_hwe_employee?
  after_update :update_calendar_event, if: :should_update_calendar? && :is_hwe_employee?
  after_destroy :remove_from_calendar, if: :should_remove_from_calendar? && :is_hwe_employee?

  # Delegate to get resume and requirement through req_match
  delegate :resume, :requirement, to: :req_match, allow_nil: true

  def is_hwe_employee?
    employee.group.present? && (employee.group.name.include?("HWE") || employee.group.name.include?("PROMOTER"))
  end

  def self.get_level_for_select
    level_array = []
    level_array.push(['L1', 1])
    level_array.push(['L2', 2])
    level_array.push(['L3', 3])
    level_array
  end

  def overlapping_interviews
    if self.employee
      # Check database for overlapping interviews
      check_database_overlaps
      
      # Check Microsoft Teams calendar for overlapping events
      if is_hwe_employee?
        check_calendar_overlaps
      end
    end
  end

  def interview_type
    itype.present? ? itype : "Technical"
  end

  def location
    # You might want to add a location field to interviews table
    # For now, return a default or get from requirement
    requirement&.location || "TBD"
  end

  def notes
    focus.present? ? focus : ""
  end

  def scheduled_at
    return nil unless interview_date && interview_time
    
    # Create the datetime in the application's timezone (IST - UTC+5:30)
    local_datetime = DateTime.new(
      interview_date.year,
      interview_date.month,
      interview_date.day,
      interview_time.hour,
      interview_time.min,
      interview_time.sec
    )
    
    # Convert from IST to UTC for Microsoft Graph compatibility
    # IST is UTC+5:30, so we need to subtract 5.5 hours to get UTC
    utc_datetime = local_datetime - 5.5.hours
    
    # Return as UTC datetime (matches Microsoft Graph timezone)
    utc_datetime.utc
  end

  private

  def check_database_overlaps
    overlapping_interviews = self.employee.interviews
      .where.not(id: self.id) # Exclude current interview if updating
      .where(interview_date: self.interview_date, interview_time: self.interview_time)
    
    if overlapping_interviews.exists?
      msg = "There is already an interview request for #{self.employee.name.titleize} with this date/time"
      errors.add(:base, :save_error, message: msg)
    end
  end

  def check_calendar_overlaps
    Rails.logger.info "Checking calendar overlaps for interview #{self.id}"
    return unless self.employee.teams_email.present? && self.interview_date.present? && self.interview_time.present?
    Rails.logger.info "Employee teams email: #{self.employee.teams_email}"
    Rails.logger.info "Interview date: #{self.interview_date}"
    Rails.logger.info "Interview time: #{self.interview_time}"
    begin
      service = MicrosoftGraphService.new
      
      # Get calendar events for the interview date
      start_date = self.interview_date.beginning_of_day
      end_date = self.interview_date.end_of_day
      
      calendar_events = service.get_user_calendar_events(
        self.employee.teams_email, 
        start_date, 
        end_date
      )
      # Log calendar events for debugging
      Rails.logger.info "Calendar events for #{self.employee.teams_email} on #{self.interview_date}:"
      calendar_events.each do |event|
        Rails.logger.info "  - #{event['subject']}: #{event['start']['dateTime']} to #{event['end']['dateTime']}"
      end
      # Check for time conflicts
      interview_start = self.scheduled_at
      interview_end = interview_start + 1.hour
      
      Rails.logger.info "Interview time range (UTC): #{interview_start.iso8601} to #{interview_end.iso8601}"
      
      calendar_events.each do |event|
        next unless event['start'] && event['end']
        
        # Parse event times (already in UTC from Microsoft Graph)
        event_start = DateTime.parse(event['start']['dateTime']).utc
        event_end = DateTime.parse(event['end']['dateTime']).utc
        
        Rails.logger.info "Calendar event '#{event['subject']}' (UTC): #{event_start.iso8601} to #{event_end.iso8601}"
        
        # Check if there's any overlap
        if (interview_start < event_end) && (interview_end > event_start)
          msg = "There is already a calendar event for #{self.employee.name.titleize} at this time: #{event['subject']}"
          Rails.logger.info "OVERLAP DETECTED: #{msg}"
          errors.add(:base, :save_error, message: msg)
        end
      end
    rescue => e
      Rails.logger.error "Error checking calendar overlaps for interview #{self.id}: #{e.message}"
    end
  end

  def date_should_not_be_less_than_current_date
    if self.interview_date
      if self.interview_date < Date.today
        errors.add(:base, :save_error, message: 'Interview date can not be earlier than today')
      end
    end
  end

  # Calendar integration methods
  def should_add_to_calendar?
    employee.email.present? && 
    interview_date.present? && 
    interview_time.present? &&
    calendar_event_id.blank?
  end

  def should_update_calendar?
    calendar_event_id.present? && 
    (saved_change_to_interview_date? || 
     saved_change_to_interview_time? || 
     saved_change_to_itype? || 
     saved_change_to_focus? ||
     saved_change_to_stage?)
  end

  def add_to_calendar
    return unless should_add_to_calendar?

    service = MicrosoftGraphService.new
    event_id = service.create_calendar_event_for_user(employee.teams_email, self)
    if event_id
      update_column(:calendar_event_id, event_id)
      Rails.logger.info "Calendar event created for interview #{id} with event ID: #{event_id}"
    else
      Rails.logger.error "Failed to create calendar event for interview #{id}"
    end
  rescue => e
    Rails.logger.error "Exception creating calendar event for interview #{id}: #{e.message}"
  end

  def update_calendar_event
    return unless calendar_event_id.present?

    service = MicrosoftGraphService.new
    if service.update_calendar_event_for_user(employee.teams_email, calendar_event_id, self)
      Rails.logger.info "Calendar event updated for interview #{id}"
    else
      Rails.logger.error "Failed to update calendar event for interview #{id}"
    end
  rescue => e
    Rails.logger.error "Exception updating calendar event for interview #{id}: #{e.message}"
  end

  def should_remove_from_calendar?
    calendar_event_id.present?
  end

  def remove_from_calendar
    return unless should_remove_from_calendar?

    service = MicrosoftGraphService.new
    if service.delete_calendar_event_for_user(employee.teams_email, calendar_event_id)
      Rails.logger.info "Calendar event removed for interview #{id}"
    else
      Rails.logger.error "Failed to remove calendar event for interview #{id}"
    end
  rescue => e
    Rails.logger.error "Exception removing calendar event for interview #{id}: #{e.message}"
  end
end

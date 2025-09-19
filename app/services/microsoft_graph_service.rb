class MicrosoftGraphService
  include HTTParty
  
  base_uri 'https://graph.microsoft.com/v1.0'
  
  def initialize
    @access_token = get_app_access_token
  end

  # Create a calendar event for interview with ta_owner as organizer
  def create_calendar_event_for_interview(interview)
    return false unless @access_token

    # Determine who should be the organizer (ta_owner if present, otherwise interviewer)
    organizer = if interview.resume.ta_owner.present? && interview.resume.ta_owner.teams_email.present?
                  interview.resume.ta_owner
                elsif interview.employee.teams_email.present?
                  interview.employee
                else
                  nil
                end

    return false unless organizer

    event_data = build_event_data(interview)
    
    # Log event data for debugging, especially for Teams meetings
    if interview.is_teams_conf?
      Rails.logger.info "Creating Teams meeting for #{interview.itype.downcase} interview: #{interview.id}"
      Rails.logger.info "Organizer: #{organizer.name} (#{organizer.teams_email})"
      Rails.logger.info "Event data: #{event_data.to_json}"
    end
    
    response = self.class.post(
      "/users/#{organizer.teams_email}/events",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      body: event_data.to_json
    )

    if response.success?
      Rails.logger.info "Calendar event created for organizer #{organizer.name}: #{response['id']}"
      if interview.is_teams_conf? && response['onlineMeeting']
        teams_url = response['onlineMeeting']['joinUrl']
        Rails.logger.info "Teams meeting created with join URL: #{teams_url}"
        # Store the Teams meeting URL in the interview
        interview.update_column(:teams_meeting_url, teams_url)
      end
      response['id'] # Return the event ID for storage
    else
      Rails.logger.error "Failed to create calendar event for organizer #{organizer.name}"
      Rails.logger.error "Response status: #{response.code}"
      Rails.logger.error "Response body: #{response.body}"
      Rails.logger.error "Request body that was sent: #{event_data.to_json}"
      false
    end
  rescue => e
    Rails.logger.error "Exception creating calendar event for interview #{interview.id}: #{e.message}"
    false
  end

  # Update a calendar event for interview with ta_owner as organizer
  def update_calendar_event_for_interview(interview, event_id)
    return false unless @access_token && event_id.present?

    # Determine who should be the organizer (ta_owner if present, otherwise interviewer)
    organizer = if interview.resume.ta_owner.present? && interview.resume.ta_owner.teams_email.present?
                  interview.resume.ta_owner
                elsif interview.employee.teams_email.present?
                  interview.employee
                else
                  nil
                end

    return false unless organizer

    event_data = build_event_data(interview)
    
    # Log event data for debugging, especially for Teams meetings
    if interview.is_teams_conf?
      Rails.logger.info "Updating Teams meeting for #{interview.itype.downcase} interview: #{interview.id}"
      Rails.logger.info "Organizer: #{organizer.name} (#{organizer.teams_email})"
      Rails.logger.info "Event data: #{event_data.to_json}"
    end
    
    response = self.class.patch(
      "/users/#{organizer.teams_email}/events/#{event_id}",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      body: event_data.to_json
    )

    if response.success?
      Rails.logger.info "Calendar event updated for organizer #{organizer.name}: #{event_id}"
      if interview.is_teams_conf? && response['onlineMeeting']
        teams_url = response['onlineMeeting']['joinUrl']
        Rails.logger.info "Teams meeting updated with join URL: #{teams_url}"
        # Update the Teams meeting URL in the interview
        interview.update_column(:teams_meeting_url, teams_url)
      end
      true
    else
      Rails.logger.error "Failed to update calendar event for organizer #{organizer.name}: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Exception updating calendar event for interview #{interview.id}: #{e.message}"
    false
  end

  # Delete a calendar event for interview with ta_owner as organizer
  def delete_calendar_event_for_interview(interview, event_id)
    return false unless @access_token && event_id.present?

    # Determine who should be the organizer (ta_owner if present, otherwise interviewer)
    organizer = if interview.resume.ta_owner.present? && interview.resume.ta_owner.teams_email.present?
                  interview.resume.ta_owner
                elsif interview.employee.teams_email.present?
                  interview.employee
                else
                  nil
                end

    return false unless organizer

    response = self.class.delete(
      "/users/#{organizer.teams_email}/events/#{event_id}",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      }
    )

    if response.success?
      Rails.logger.info "Calendar event deleted for organizer #{organizer.name}: #{event_id}"
      true
    else
      Rails.logger.error "Failed to delete calendar event for organizer #{organizer.name}: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Exception deleting calendar event for interview #{interview.id}: #{e.message}"
    false
  end

  # Get all users in the organization (for testing/debugging)
  def get_organization_users
    return [] unless @access_token

    response = self.class.get(
      "/users",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      query: {
        '$select' => 'id,displayName,mail,userPrincipalName',
        '$top' => 100
      }
    )

    if response.success?
      response['value']
    else
      Rails.logger.error "Failed to get organization users: #{response.body}"
      []
    end
  rescue => e
    Rails.logger.error "Exception getting organization users: #{e.message}"
    []
  end

  # Get calendar events for a specific user (includes recurring meetings)
  def get_user_calendar_events(user_email, start_date = nil, end_date = nil)
    return [] unless @access_token && user_email.present?

    # Default to current month if no dates provided
    start_date ||= Date.current.beginning_of_month
    end_date ||= Date.current.end_of_month

    # Use calendarView endpoint to get expanded recurring events
    query_params = {
      '$select' => 'subject,start,end,location,attendees,body,organizer,recurrence,isAllDay',
      '$orderby' => 'start/dateTime asc'
    }

    # Format dates for calendarView (requires specific format)
    # Convert local dates to UTC for Microsoft Graph
    start_time = start_date.beginning_of_day.utc.iso8601
    end_time = end_date.end_of_day.utc.iso8601

    response = self.class.get(
      "/users/#{user_email}/calendarView",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      query: query_params.merge(
        'startDateTime' => start_time,
        'endDateTime' => end_time
      )
    )

    if response.success?
      response['value'] || []
    else
      Rails.logger.error "Failed to get calendar events for #{user_email}: #{response.body}"
      []
    end
  rescue => e
    Rails.logger.error "Exception getting calendar events for #{user_email}: #{e.message}"
    []
  end

  # Get calendar events for multiple users (team members)
  def get_team_calendar_events(user_emails, start_date = nil, end_date = nil)
    return [] if user_emails.blank?

    all_events = []
    user_emails.each do |email|
      events = get_user_calendar_events(email, start_date, end_date)
      events.each do |event|
        event['user_email'] = email
        all_events << event
      end
    end

    # Sort by start time
    all_events.sort_by { |event| event.dig('start', 'dateTime') || '' }
  end

  private

  def get_app_access_token
    response = self.class.post(
      "https://login.microsoftonline.com/#{APP_CONFIG['microsoft_tenant_id']}/oauth2/v2.0/token",
      body: {
        client_id: APP_CONFIG['microsoft_client_id'],
        client_secret: APP_CONFIG['microsoft_client_secret'],
        scope: 'https://graph.microsoft.com/.default',
        grant_type: 'client_credentials'
      }
    )

    if response.success?
      Rails.logger.info "Successfully obtained Microsoft Graph access token"
      response['access_token']
    else
      Rails.logger.error "Failed to get Microsoft Graph access token: #{response.body}"
      nil
    end
  rescue => e
    Rails.logger.error "Exception getting Microsoft Graph access token: #{e.message}"
    nil
  end

  def build_event_data(interview)
    event_data = {
      subject: "Interview - #{interview.resume.name} (#{interview.requirement.name})",
      body: {
        contentType: "HTML",
        content: build_event_content(interview)
      },
      start: {
        dateTime: interview.scheduled_at.iso8601,
        timeZone: "UTC"
      },
      end: {
        dateTime: (interview.scheduled_at + (interview.duration || 60).minutes).iso8601,
        timeZone: "UTC"
      },
      attendees: build_attendees(interview),
      isReminderOn: true,
      reminderMinutesBeforeStart: 15
    }

    # Add Teams meeting for telephonic and video interviews
    if interview.is_teams_conf?
      event_data[:isOnlineMeeting] = true
      event_data[:onlineMeetingProvider] = "teamsForBusiness"
    end

    event_data
  end

  def build_event_content(interview)
    content = <<~HTML
      <h3>Interview Details</h3>
      <p><strong>Candidate:</strong> <a href="#{Rails.application.routes.url_helpers.resume_url(interview.resume.uniqid.name, host: APP_CONFIG['host_name'])}">#{interview.resume.name}</a></p>
      <p><strong>Position:</strong> #{interview.requirement.name}</p>
      <p><strong>Interviewer:</strong> #{interview.employee.name}</p>
    HTML

    # Add ta_owner information if present and different from interviewer
    if interview.resume.ta_owner.present? && interview.resume.ta_owner != interview.employee
      content += <<~HTML
        <p><strong>TA Owner:</strong> #{interview.resume.ta_owner.name}</p>
      HTML
    end

    content += <<~HTML
      <p><strong>Type:</strong> #{interview.interview_type}</p>
      <p><strong>Notes:</strong> #{interview.notes}</p>
    HTML

    # Add Teams meeting information for telephonic and video interviews
    if interview.is_teams_conf?
      content += <<~HTML
        <br>
        <h4>Teams Meeting</h4>
        <p>This is a telephonic interview that will be conducted via Microsoft Teams. Please join the meeting at the scheduled time.</p>
      HTML
    end

    content
  end

  def build_attendees(interview)
    attendees = []
    
    # Add interviewer as attendee (not organizer)
    if interview.employee.teams_email.present?
      attendees << {
        emailAddress: {
          address: interview.employee.teams_email,
          name: interview.employee.name
        },
        type: "required"
      }
    end
    attendees
  end
end

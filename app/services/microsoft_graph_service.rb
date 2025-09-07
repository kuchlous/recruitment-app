class MicrosoftGraphService
  include HTTParty
  
  base_uri 'https://graph.microsoft.com/v1.0'
  
  def initialize
    @access_token = get_app_access_token
  end

  # Create a calendar event for a specific user
  def create_calendar_event_for_user(user_email, interview)
    return false unless @access_token && user_email.present?

    event_data = build_event_data(interview)
    
    response = self.class.post(
      "/users/#{user_email}/events",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      body: event_data.to_json
    )

    if response.success?
      Rails.logger.info "Calendar event created for #{user_email}: #{response['id']}"
      response['id'] # Return the event ID for storage
    else
      Rails.logger.error "Failed to create calendar event for #{user_email}: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Exception creating calendar event for #{user_email}: #{e.message}"
    false
  end

  # Update a calendar event for a specific user
  def update_calendar_event_for_user(user_email, event_id, interview)
    return false unless @access_token && user_email.present? && event_id.present?

    event_data = build_event_data(interview)
    
    response = self.class.patch(
      "/users/#{user_email}/events/#{event_id}",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      body: event_data.to_json
    )

    if response.success?
      Rails.logger.info "Calendar event updated for #{user_email}: #{event_id}"
      true
    else
      Rails.logger.error "Failed to update calendar event for #{user_email}: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Exception updating calendar event for #{user_email}: #{e.message}"
    false
  end

  # Delete a calendar event for a specific user
  def delete_calendar_event_for_user(user_email, event_id)
    return false unless @access_token && user_email.present? && event_id.present?

    response = self.class.delete(
      "/users/#{user_email}/events/#{event_id}",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      }
    )

    if response.success?
      Rails.logger.info "Calendar event deleted for #{user_email}: #{event_id}"
      true
    else
      Rails.logger.error "Failed to delete calendar event for #{user_email}: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Exception deleting calendar event for #{user_email}: #{e.message}"
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

  # Get calendar events for a specific user
  def get_user_calendar_events(user_email, start_date = nil, end_date = nil)
    return [] unless @access_token && user_email.present?

    # Default to current month if no dates provided
    start_date ||= Date.current.beginning_of_month
    end_date ||= Date.current.end_of_month

    query_params = {
      '$select' => 'subject,start,end,location,attendees,body,organizer',
      '$orderby' => 'start/dateTime asc'
    }

    # Add date filter if provided
    if start_date && end_date
      query_params['$filter'] = "start/dateTime ge '#{start_date.iso8601}' and start/dateTime le '#{end_date.iso8601}'"
    end

    response = self.class.get(
      "/users/#{user_email}/events",
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      query: query_params
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
    {
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
        dateTime: (interview.scheduled_at + 1.hour).iso8601,
        timeZone: "UTC"
      },
      attendees: build_attendees(interview),
      isReminderOn: true,
      reminderMinutesBeforeStart: 15
    }
  end

  def build_event_content(interview)
    <<~HTML
      <h3>Interview Details</h3>
      <p><strong>Candidate:</strong> <a href="#{Rails.application.routes.url_helpers.resume_url(interview.resume.uniqid.name, host: APP_CONFIG['host_name'])}">#{interview.resume.name}</a></p>
      <p><strong>Position:</strong> #{interview.requirement.name}</p>
      <p><strong>Interviewer:</strong> #{interview.employee.name}</p>
      <p><strong>Type:</strong> #{interview.interview_type}</p>
      <p><strong>Notes:</strong> #{interview.notes}</p>
    HTML
  end

  def build_attendees(interview)
    attendees = []
    
    # Add interviewer
    if interview.employee.email.present?
      attendees << {
        emailAddress: {
          address: interview.employee.email,
          name: interview.employee.name
        },
        type: "required"
      }
    end

    attendees
  end
end

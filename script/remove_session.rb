class RemoveSession < ActiveRecord::Base
  # Delete the cookies that are older than a day
  old_sessions = Session.find(:all, :conditions => ["updated_at < ?", 24.hours.ago])
  if old_sessions.size > 0
    for session in old_sessions
      Session.destroy(session)
    end
    info = "#{old_sessions.size} old sessions are deleted at #{Time.now}"
    logger.info(info)
  end
end

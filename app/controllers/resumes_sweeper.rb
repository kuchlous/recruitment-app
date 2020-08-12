class ResumeSweeper < ActionController::Caching::Sweeper
  observe Resume

  def after_update(resume)
    # self.controller ||= ActionController::Base.new
    # expire_action(:host => APP_CONFIG["host_name"], :controller => 'resumes', :action => 'joined')
    ActionController::Base.new.expire_fragment('joined')
    # Fill the cache again
    # if (ENV["RAILS_ENV"] == "production")
      # system("/apps/20101003172934/script/refresh_join_cache.sh &")
    # end
  end

end

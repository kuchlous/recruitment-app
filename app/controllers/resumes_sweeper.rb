class ResumesSweeper < ActionController::Caching::Sweeper
  observe Resume

  def after_update(resume)
    expire_action(:controller => 'resumes', :action => 'joined')
    # Fill the cache again
    if (ENV["RAILS_ENV"] == "production")
      system("/apps/20101003172934/script/refresh_join_cache.sh &")
    end
  end

end

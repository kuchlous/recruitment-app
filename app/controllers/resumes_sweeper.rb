#class ResumesSweeper < ActionController::Caching::Sweeper
#  observe Resume
#
#  def after_update(resume)
#    expire_action(:controller => 'resumes', :action => 'joined')
#    # Fill the cache again
#    if (Rails.env == "production")
#      system("/var/www/html/recruitment/current/script/refresh_join_cache.sh &")
#    end
#  end
#
#end

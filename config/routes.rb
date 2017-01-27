ActionController::Routing::Routes.draw do |map|
  map.resources :groups, :portals, :agencies, :designations
  map.resources :requirements, :collection => { :req_analysis => :any, :all_reqs => :any }
  map.resources :employees, :collection => { :logout => :any,
                                           :list_my_employees => :any }
  map.resources :resumes,   :collection => { :inbox               => :any,
                                           :outbox                => :any,
                                           :trash                 => :any,
                                           :export_as_xls         => :any,
                                           :export_interviews     => :any,
                                           :export_as_xls_requirement                   => :any,
                                           :export_as_xls_requirement_for_shortlisted   => :any,
                                           :export_as_xls_requirement_for_forwards      => :any,
                                           :export_as_xls_requirement_for_offered       => :any,
                                           :export_as_xls_requirement_for_scheduled     => :any,
                                           :export_as_xls_requirement_for_rejected      => :any,
                                           :export_as_xls_requirement_for_hold          => :any,
                                           :export_as_xls_requirement_for_joining       => :any,
                                           :export_as_xls_all_uploaded_resumes          => :any,
                                           :joined                => :any,
                                           :hold                  => :any,
                                           :offered               => :any,
                                           :rejected              => :any,
                                           :future                => :any,
                                           :interview_requests    => :any,
                                           :download_resume       => :any,
                                           :manager_joined        => :any,
                                           :manager_offered       => :any,
                                           :manager_hold          => :any,
                                           :shortlisted           => :any,
                                           :forwarded             => :any,
                                           :new_resumes           => :any,
                                           :interviews_status     => :any,
                                           :interviews_status_new => :any,
                                           :manager_index         => :any,
                                           :manager_shortlisted   => :any,
                                           :manager_rejected      => :any,
                                           :manager_interviews_status    => :any,
                                           :interview_calendar    => :any,
                                           :get_interviews        => :any,
                                           :my_resumes            => :any,
                                           :recent                => :any,
                                           :find_resume_in_given_date    => :any,
                                           :upload_xls                   => :any,
                                           :update_resume_likely_to_join => :any,
                                           :process_xls_and_zipped_resumes => :any,
                                           :close_requirement     => :any,
                                           :export_interviews_per_date     => :any
                                         }
  map.resources :home,   :collection => { :advanced_search               => :any,
                                          :index => :any,
                                          :actions => :any,
                                          :summaries => :any,
                                          :actions_page => :any,
                                          :search => :any,
                                          :advanced_search_results => :any,
                                          :show_summary_per_recruiter => :any,
                                          :show_summary_per_manager => :any,
                                          :show_summary_per_interviewer => :any
  }

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  map.connect ':controller',
               :action     => "index"
  map.root     :controller => "home"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

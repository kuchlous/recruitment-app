Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  # resources :employees'
  # resources :resumes
  match 'login', to: 'employees#login'                              , via: :post
  match 'logout', to: 'employees#logout'                            , via: :get
  resources :requirements
  match 'requirements/my_requirements', to: 'requirements#my_requirements'  , via: :get
  match 'requirements/req_analysis', to: 'requirements#req_analysis'        , via: :get
  match 'requirements/all_reqs', to: 'requirements#all_reqs'                , via: :get
  match 'requirements/search', to: 'requirements#search'                    , via: :post
  match 'requirements/close_requirement', to: 'requirements#close_requirement' , via: :post
  match 'home/search', to: 'home#search'                                       , via: :post
  match 'home/actions', to: 'home#actions'                                     , via: :get
  match 'home/advanced_search_results', to: 'home#advanced_search_results'     , via: :get
  match 'home/advanced_search', to: 'home#advanced_search'          , via: :get
  match 'home/actions_page', to: 'home#actions_page'                , via: :get
  match 'home/dashboard', to: 'home#dashboard'                      , via: :get
  match 'designations/index', to: 'designations#index'              , via: :get
  match 'groups/index', to: 'groups#index'                          , via: :get
  match 'portals/index', to: 'portals#index'                        , via: :get
  match 'agencies/index', to: 'agencies#index'                      , via: :get
  match 'resumes/new_resumes', to: 'resumes#new_resumes'            , via: :get
  match 'resumes/inbox',to: 'resumes#inbox'                         , via: :get
  match 'resumes/outbox',to: 'resumes#outbox'                       , via: :get
  match 'resumes/trash',to: 'resumes#trash'                         , via: :get
  match 'resumes/export_as_xls',to: 'resumes#export_as_xls'         , via: :get
  match 'resumes/export_interviews',to: 'resumes#export_interviews' , via: :get
  match 'resumes/find_resume_within_given_dates',to: 'resumes#find_resume_within_given_dates' , via: :get
  match 'employees/list_my_employees',to: 'employees#list_my_employees' , via: :get
  match 'employees/change_to',to: 'employees#change_to' , via: :get




  match 'resumes/export_as_xls_requirement',to: 'resumes#export_as_xls_requirement'                                , via: :get
  match 'resumes/export_as_xls_requirement_for_shortlisted',to: 'resumes#export_as_xls_requirement_for_shortlisted', via: :get
  match 'resumes/export_as_xls_requirement_for_forwards',to: 'resumes#export_as_xls_requirement_for_forwards'      , via: :get
  match 'resumes/export_as_xls_requirement_for_offered',to: 'resumes#export_as_xls_requirement_for_offered'        , via: :get 
  match 'resumes/export_as_xls_requirement_for_scheduled',to: 'resumes#export_as_xls_requirement_for_scheduled'    , via: :get
  match 'resumes/export_as_xls_requirement_for_rejected',to: 'resumes#export_as_xls_requirement_for_rejected'      , via: :get
  match 'resumes/export_as_xls_requirement_for_hold',to: 'resumes#export_as_xls_requirement_for_hold'              , via: :get
  match 'resumes/export_as_xls_requirement_for_joining',to: 'resumes#export_as_xls_requirement_for_joining'        , via: :get
  match 'resumes/xport_as_xls_all_uploaded_resumes',to: 'resumes#export_as_xls_all_uploaded_resumes'               , via: :get  
  match 'resumes/joined',to: 'resumes#joined'                , via: :get
  match 'resumes/show/:id',to: 'resumes#show'                , via: :get
  match 'resumes/hold',to: 'resumes#hold'                    , via: :get
  match 'resumes/offered',to: 'resumes#offered'              , via: :get
  match 'resumes/rejected',to: 'resumes#rejected'            , via: :get
  match 'resumes/future',to: 'resumes#future'                , via: :get
  match 'resumes/interview_requests',to: 'resumes#interview_requests'       , via: :get
  match 'resumes/download_resume',to: 'resumes#download_resume'             , via: :get
  match 'resumes/manager_joined',to: 'resumes#manager_joined'               , via: :get
  match 'resumes/manager_offered',to: 'resumes#manager_offered'             , via: :get
  match 'resumes/manager_hold',to: 'resumes#manager_hold'                   , via: :get
  match 'resumes/shortlisted',to: 'resumes#shortlisted'                     , via: :get
  match 'resumes/forwarded',to: 'resumes#forwarded'                         , via: :get
  match 'resumes/new_resumes',to: 'resumes#new_resumes'                     , via: :get
  match 'resumes/interviews_status',to: 'resumes#interviews_status'         , via: :get
  match 'resumes/interviews_status_new',to: 'resumes#interviews_status_new' , via: :get
  match 'resumes/manager_index',to: 'resumes#manager_index'                 , via: :get
  match 'resumes/manager_shortlisted',to: 'resumes#manager_shortlisted'     , via: :get
  match 'resumes/manager_rejected',to: 'resumes#manager_rejected'           , via: :get
  match 'resumes/manager_interviews_status',to: 'resumes#manager_interviews_status'           , via: :get
  match 'resumes/interview_calendar',to: 'resumes#interview_calendar'       , via: :get
  match 'resumes/get_interviews',to: 'resumes#get_interviews'               , via: :get 
  match 'resumes/my_resumes',to: 'resumes#my_resumes'                       , via: :get
  match 'resumes/recent',to: 'resumes#recent'                               , via: :get
  match 'resumes/find_resume_in_given_date',to: 'resumes#find_resume_in_given_date'           , via: :get
  match 'resumes/upload_xls',to: 'resumes#upload_xls'                       , via: :get
  match 'resumes/update_resume_likely_to_join',to: 'resumes#update_resume_likely_to_join'     , via: :get
  match 'resumes/process_xls_and_zipped_resumes',to: 'resumes#process_xls_and_zipped_resumes' , via: :get
  match 'resumes/close_requirement',to: 'resumes#close_requirement'                           , via: :get
  match 'resumes/export_interviews_per_date',to: 'resumes#export_interviews_per_date'         , via: :get
  match 'resumes/yto',to: 'resumes#yto'                                                       , via: :get
  match 'resumes/manager_yto',to: 'resumes#manager_yto'                                       , via: :get
  match 'resumes/move_to_future',to: 'resumes#move_to_future'                                       , via: :post
  match 'resumes/reject_all_forwards_req_matches',to: 'resumes#reject_all_forwards_req_matches'                                       , via: :post
  match 'resumes/mark_active',to: 'resumes#mark_active'                                       , via: :post

 resources :resumes
 resources :portals
 resources :agencies
 resources :groups
 resources :designations
end

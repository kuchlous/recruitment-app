Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  # resources :resumes
  get 'resumes/phone_autocomplete', to: 'resumes#phone_autocomplete', as: :resumes_phone_autocomplete
  get 'resumes/email_autocomplete', to: 'resumes#email_autocomplete', as: :resumes_email_autocomplete
  get 'resumes/get_summary_by_id', to: 'resumes#get_summary_by_id', as: :resumes_get_summary_by_id

  get 'employees/autocomplete', to: 'employees#employees_autocomplete', as: :employees_autocomplete
  match 'login', to: 'employees#login'                                         , via: :post
  match 'logout', to: 'employees#logout'                                       , via: :get
  match 'requirements/my_requirements', to: 'requirements#my_requirements'     , via: :get
  match 'requirements/req_analysis', to: 'requirements#req_analysis'           , via: :get
  match 'requirements/all_reqs', to: 'requirements#all_reqs'                   , via: :get
  match 'requirements/search', to: 'requirements#search'                       , via: :post
  match 'requirements/close_requirement', to: 'requirements#close_requirement' , via: :post
  resources :requirements
  match 'add_interviewer', to: 'interview_skills#add_interviewer'              ,via: :post
  match 'interview_skills/create', to: 'interview_skills#create'                             ,via: :post
  match 'interview_skills/:id', to: 'interview_skills#destroy'                                       , via: :delete
  match 'home/interview-panels', to: 'home#interview_panels'                                       , via: :get
  match 'home/search', to: 'home#search'                                       , via: :post
  match 'home/search', to: 'home#search'                                       , via: :get
  match 'home/show_summary_per_interviewer', to:'home#show_summary_per_interviewer'                                       , via: :get
  match 'home/show_summary_per_recruiter', to: 'home#show_summary_per_recruiter'                                     , via: :get

  match 'home/show_summary_per_manager', to: 'home#show_summary_per_manager'                                     , via: :get
  match 'home/actions', to: 'home#actions'                                     , via: :get
  match 'home/advanced_search_results', to: 'home#advanced_search_results'     , via: :get
  match 'home/advanced_search', to: 'home#advanced_search'          , via: :get
  match 'home/actions_page', to: 'home#actions_page'                , via: :get
  match 'home/dashboard', to: 'home#dashboard'                      , via: :get
  match 'home/summaries', to: 'home#summaries'                      , via: :get
  match 'designations/index', to: 'designations#index'              , via: :get
  match 'groups/index', to: 'groups#index'                          , via: :get
  match 'portals/index', to: 'portals#index'                        , via: :get
  match 'agencies/index', to: 'agencies#index'                      , via: :get
  match 'resumes/new_resumes', to: 'resumes#new_resumes'            , via: :get
  match 'resumes/inbox',to: 'resumes#inbox'                         , via: :get
  match 'resumes/outbox',to: 'resumes#outbox'                       , via: :get
  match 'resumes/trash',to: 'resumes#trash'                         , via: :get
  match 'resumes/resume_action',to: 'resumes#resume_action'         , via: :post
  match 'resumes/eng_select',to: 'resumes#eng_select'               , via: :get
  match 'resumes/hac',to: 'resumes#hac'                             , via: :get
  match 'resumes/send_for_eng_decision',to:'resumes#send_for_eng_decision'   , via: :post
  match 'resumes/send_for_decision',to: 'resumes#send_for_decision'          , via: :post
  match 'resumes/manager_eng_select',to: 'resumes#manager_eng_select'        , via: :get
  match 'resumes/manager_hac',to: 'resumes#manager_hac'                      , via: :get
  match 'resumes/manage_interviews',to: 'resumes#manage_interviews'          , via: :post
  match 'resumes/show_resume_comments',to: 'resumes#show_resume_comments'    , via: :post
  match 'resumes/export_as_xls',to: 'resumes#export_as_xls'                  , via: :get
  match 'resumes/export_interviews',to: 'resumes#export_interviews'          , via: :get
  match 'resumes/find_resume_within_given_dates',to: 'resumes#find_resume_within_given_dates' , via: :get
  match 'employees/list_my_employees',to: 'employees#list_my_employees'          , via: :get
  match 'employees/change_to',to: 'employees#change_to'                          , via: :get
  match 'resumes/export_as_xls_requirement',to:'resumes#export_as_xls_requirement' , via: :get
  match 'resumes/export_as_xls_requirement_for_shortlisted',to: 'resumes#export_as_xls_requirement_for_shortlisted', via: :get
  match 'resumes/export_as_xls_requirement_for_forwards',to: 'resumes#export_as_xls_requirement_for_forwards'      , via: :get
  match 'resumes/export_as_xls_requirement_for_offered',to: 'resumes#export_as_xls_requirement_for_offered'        , via: :get 
  match 'resumes/export_as_xls_requirement_for_scheduled',to: 'resumes#export_as_xls_requirement_for_scheduled'    , via: :get
  match 'resumes/export_as_xls_requirement_for_rejected',to: 'resumes#export_as_xls_requirement_for_rejected'      , via: :get
  match 'resumes/export_as_xls_requirement_for_hold',to: 'resumes#export_as_xls_requirement_for_hold'              , via: :get
  match 'resumes/export_as_xls_requirement_for_joining',to: 'resumes#export_as_xls_requirement_for_joining'        , via: :get
  match 'resumes/xport_as_xls_all_uploaded_resumes',to: 'resumes#export_as_xls_all_uploaded_resumes'               , via: :get  
  match 'resumes/joined',to: 'resumes#joined'                , via: :get
  match 'resumes/upload_document',to: 'resumes#upload_document'         , via: :post
  match 'get_resume_attachment', to: 'resumes#get_resume_attachment'    , via: :get 
  match 'resumes/show/:id',to: 'resumes#show'                , via: :get
  match 'resumes/hold',to: 'resumes#hold'                    , via: :get
  match 'resumes/offered',to: 'resumes#offered'              , via: :get
  match 'resumes/rejected',to: 'resumes#rejected'            , via: :get
  match 'resumes/future',to: 'resumes#future'                , via: :get
  match 'resumes/submit_ph_rating',to: 'resumes#submit_ph_rating'                , via: :post
  match 'resumes/interview_requests',to: 'resumes#interview_requests'       , via: :get
  match 'resumes/get_interviews',to: 'resumes#get_interviews'               , via: :get
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
  match 'resumes/manager_interviews_status',to: 'resumes#manager_interviews_status'   , via: :get
  match 'resumes/interview_calendar',to: 'resumes#interview_calendar'       , via: :get
  match 'resumes/get_interviews',to: 'resumes#get_interviews'               , via: :get 
  match 'resumes/my_resumes',to: 'resumes#my_resumes'                       , via: :get
  match 'resumes/recent',to: 'resumes#recent'                               , via: :get
  match 'resumes/find_resume_in_given_date',to: 'resumes#find_resume_in_given_date'   , via: :get
  match 'resumes/upload_xls',to: 'resumes#upload_xls'                                 , via: :get
  match 'resumes/update_resume_likely_to_join',to: 'resumes#update_resume_likely_to_join'     , via: :get
  match 'resumes/process_xls_and_zipped_resumes',to: 'resumes#process_xls_and_zipped_resumes' , via: :get
  match 'resumes/close_requirement',to: 'resumes#close_requirement'                           , via: :get
  match 'resumes/export_interviews_per_date',to: 'resumes#export_interviews_per_date'         , via: :get
  match 'resumes/yto',to: 'resumes#yto'                                                       , via: :get
  match 'resumes/manager_yto',to: 'resumes#manager_yto'                                       , via: :get
  match 'resumes/show_quarterly_joined',to: 'resumes#show_quarterly_joined'                   , via: :get
  match 'resumes/show_all_joined_or_not_joined',to: 'resumes#show_all_joined_or_not_joined'   , via: :get
  match 'resumes/show_quarterly_offered',to: 'resumes#show_quarterly_offered'                 , via: :get
  match 'resumes/show_all_offered',to: 'resumes#show_all_offered'                             , via: :get
  match 'resumes/show_quarterly_not_accepted',to: 'resumes#show_quarterly_not_accepted'       , via: :get
  match 'resumes/show_all_not_accepted',to: 'resumes#show_all_not_accepted'                   , via: :get
  match 'resumes/delete_interview',to: 'resumes#delete_interview'                             , via: :get

  match 'resumes/update_interview',to: 'resumes#update_interview'                                       , via: :post

  match 'resumes/move_to_future',to: 'resumes#move_to_future'                                       , via: :post
  match 'resumes/update_joining',to: 'resumes#update_joining'                                       , via: :post

  match 'resumes/reject_all_forwards_req_matches',to:'resumes#reject_all_forwards_req_matches' , via: :post
  match 'resumes/mark_active',to: 'resumes#mark_active'                    , via: :post
  match 'resumes/add_interviews',to: 'resumes#add_interviews'              ,via: :post
  match 'resumes/feedback',to: 'resumes#feedback'                          ,via: :post
  match 'resumes/show_resume_feedback',to: 'resumes#show_resume_feedback'  ,via: :post
  match 'resumes/decline_interview',to: 'resumes#decline_interview'        ,via: :post
  match 'resumes/add_manual_status_to_resume',to: 'resumes#add_manual_status_to_resume'  ,via: :post
  match 'resumes/create_multiple_forwards',to: 'resumes#create_multiple_forwards'  ,via: :post
  match 'resumes/add_message',to: 'resumes#add_message'  ,via: :post
  match 'resumes/add_interview_status_to_req_matches',to: 'resumes#add_interview_status_to_req_matches'  ,via: :post
  match 'resumes/mark_joining',to: 'resumes#mark_joining'  ,via: :post
  match 'resumes/mark_not_accepted',to: 'resumes#mark_not_accepted'  ,via: :post
  match 'resumes/find_resume_within_given_dates',to: 'resumes#find_resume_within_given_dates'  ,via: :post


 
 resources :employees
 resources :resumes
 resources :portals
 resources :agencies
 resources :groups
 resources :designations
end

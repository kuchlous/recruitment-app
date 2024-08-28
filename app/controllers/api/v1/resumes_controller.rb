module Api
  module V1
    class ResumesController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      before_action :restrict_access

      # GET /resumes/joined
      def joined
        begin
          data = []
          since_year = params[:since_year] ? params[:since_year] : Date.today.year
          resumes = Resume.where('joining_date >= ?', "#{since_year}-01-01")

          resumes.each do |resume|
            matches = resume.req_matches
            requirement_names = []
            matches.each {|match| requirement_names << match.requirement.name } 
            data << {
              name: resume.name, 
              requirement: requirement_names.join(', '), 
              joining_date: resume.joining_date.present? ? resume.joining_date.strftime("%d-%b-%y") : nil, 
              experience: resume.experience,
              status: resume.status
            }
          end

          render json: { ok: true, data: data }
        rescue Exception => e
          render json: { ok: false, error: e.to_s }
        end
      end

      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          ApiKey.exists?(access_token: token)
        end
      end
    end
  end
end
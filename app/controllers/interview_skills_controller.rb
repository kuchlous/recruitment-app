class InterviewSkillsController < ApplicationController
    def create
        InterviewSkill.create(name:params[:skill])
        redirect_back(fallback_location: root_path)
    end
end
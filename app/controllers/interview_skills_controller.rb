class InterviewSkillsController < ApplicationController
    def create
        InterviewSkill.create(name:params[:skill])
        redirect_back(fallback_location: root_path)
    end
    def destroy
        employee=Employee.find(params[:id])
        skill=InterviewSkill.find(params[:skill_id])
        employee.interview_skills.delete(skill)
        redirect_back(fallback_location: root_path) 
    end
end
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

    def add_interviewer
        eid=params[:new_interviewer].split("-")[1].strip
        employee=Employee.find_by_eid(eid)
        skill=InterviewSkill.find(params[:skill_id])
        if skill.interviewers.include?(employee)
            flash[:notice] = "Interviewer already exists."
        else
            employee.interview_skills.push(skill)
            flash[:notice] = "Interviewer added succesfully."
        end
        redirect_back(fallback_location: root_path)     
    end
end
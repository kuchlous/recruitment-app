class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:edit, :update, :view]
  before_action :check_for_login

  def view
    @interview = @feedback.interview
    @resume = @feedback.resume
  end
  
  def update
    if @feedback.update(feedback_params)
      redirect_to resume_path(@feedback.resume), notice: 'Feedback was successfully updated.'
    else
      render :edit
    end
  end

  def submit
    rating = params[:feedback_rating]
    feedback_form_json = params[:form_data]

    feedback = Feedback.new(interview_id: params[:interview_id], rating: rating, feedback_form_json: feedback_form_json)
    feedback.employee = get_current_employee
    feedback.resume_id = params[:resume_id]
    feedback.feedback = params[:feedback_common_comment]
    
    if feedback.save
      # Sending email about feedback
      Emailer.feedback(get_current_employee, feedback.resume, feedback.interview.requirement, feedback).deliver_now
      render json: { 
        status: 'success', 
        message: 'Feedback submitted successfully',
        feedback_id: feedback.id 
      }, status: :ok
    else
      render json: { 
        status: 'error', 
        message: 'Failed to submit feedback',
        errors: feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :feedback, :feedback_form_json)
  end
end

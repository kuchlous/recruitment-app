class Api::RequirementsController < ApplicationController
  before_action :check_for_login
  layout false 

  def index
    if params[:status] == 'closed'
      @requirements = Requirement.where.not(status: ['OPEN', 'HOLD']).order(created_at: :desc)
    elsif params[:status] == 'all'
      @requirements = Requirement.all.order(created_at: :desc)
    else
      @requirements = Requirement.where(status: ['OPEN', 'HOLD']).order(created_at: :desc)
    end
  end
end
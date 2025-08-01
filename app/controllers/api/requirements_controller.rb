class Api::RequirementsController < ApplicationController
  before_action :check_for_login
  layout false 

  def index
    @requirements = Requirement.where(status: ['OPEN', 'HOLD']).order(created_at: :desc)
  end
end
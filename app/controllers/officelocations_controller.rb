class OfficelocationsController < ApplicationController
  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def index
    @officelocations = Officelocation.all.order(:name)
  end

  def new
    @officelocation = Officelocation.new
  end

  def create
    @officelocation = Officelocation.new(officelocation_params)
    
    if @officelocation.save
      flash[:success] = "Office location '#{@officelocation.name}' created successfully"
      redirect_to officelocations_path
    else
      flash[:error] = "Failed to create office location: #{@officelocation.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def edit
    @officelocation = Officelocation.find(params[:id])
  end

  def update
    @officelocation = Officelocation.find(params[:id])
    
    if @officelocation.update(officelocation_params)
      flash[:success] = "Office location '#{@officelocation.name}' updated successfully"
      redirect_to officelocations_path
    else
      flash[:error] = "Failed to update office location: #{@officelocation.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  private

  def officelocation_params
    params.require(:officelocation).permit(:name, :address, :city, :state, :pincode)
  end
end

class DesignationsController < ApplicationController
  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def index
    @designations = Designation.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @designation = Designation.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @designation = Designation.new(params.require(:designation).permit!)
    respond_to do |format|
      if @designation.save
        flash[:success] = "Added designation: #{@designation.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@designation)
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @designation = Designation.find(params[:id])
  end

  def update
    @designation = Designation.find(params[:id])
    respond_to do |format|
      if @designation.update_attributes(params.require(:designation).permit!)
        flash[:success] = "Updated designation: #{@designation.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@designation)
        format.html { render :action => "edit" }
      end
    end
  end


end

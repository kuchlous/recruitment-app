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
    @designation = Designation.new(params[:designation])
    respond_to do |format|
      if @designation.save
        flash[:notice] = "#{@designation.name} added successfully"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@designation)
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
      if @designation.update_attributes(params[:designation])
        flash[:notice] = "#{@designation.name} updated successfully"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@designation)
        format.html { render :action => "edit" }
      end
    end
  end

  def error_catching_and_flashing(object)
    unless object.valid?
      object.errors.each_full { |mesg|
        logger.info(mesg)
      }
    end
  end

end

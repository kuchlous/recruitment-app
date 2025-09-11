class GroupsController < ApplicationController

  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def index
    @groups = Group.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @employees = get_all_employees
    @group  = Group.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @employees = get_all_employees
    @group = Group.new(params.require(:group).permit!)
    respond_to do |format|
      if @group.save
        flash[:success] = "Created group: #{@group.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@group)
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @employees = get_all_employees
    @group = Group.find(params[:id])
  end

  def update
    @employees = get_all_employees
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update_attributes(params.require(:group).permit!)
        flash[:success] = "Updated group: #{@group.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@group)
        format.html { render :action => "edit" }
      end
    end
  end

  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def destroy
    message = "Deleting an department will cause major percussions. So it is advisable
               not to delete department. However, if you really want to delete it then
               please ask your administrator"
    flash[:warning] = message
    redirect_back(fallback_location: root_path)
  end

end

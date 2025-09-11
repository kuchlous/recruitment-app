class PortalsController < ApplicationController

  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def index
    @portals = Portal.all

    respond_to do |format|
      format.html
    end
  end

  def new
    @portal = Portal.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @portal = Portal.new(params.require(:portal).permit!)
    respond_to do |format|
      if @portal.save
        flash[:success] = "Created portal: #{@portal.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@portal)
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @portal = Portal.find(params[:id])
  end

  def update
    @portal = Portal.find(params[:id])
    respond_to do |format|
      if @portal.update_attributes(params.require(:portal).permit!)
        flash[:success] = "Updated portal: #{@portal.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@portal)
        format.html { render :action => "edit" }
      end
    end
  end


end

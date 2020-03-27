class PortalsController < ApplicationController

  before_filter :check_for_login
  before_filter :check_for_HR_or_ADMIN

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
    @portal = Portal.new(params[:portal])
    respond_to do |format|
      if @portal.save
        flash[:notice] = "Please press F5 once if you are adding
                          this portal in employee referral"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@portal)
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
      if @portal.update_attributes(params[:portal])
        flash[:notice] = "You have successfully updated portal (#{@portal.name})"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@portal)
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

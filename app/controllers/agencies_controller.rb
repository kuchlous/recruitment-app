class AgenciesController < ApplicationController

  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def index
    @agencies = Agency.all
  end

  def new
    @agency = Agency.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @agency = Agency.new(params.require(:agency).permit!)
    respond_to do |format|
      if @agency.save
        flash[:notice] = "Please press F5 once if you are adding
                          this agency in employee referral"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@agency)
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @agency = Agency.find(params[:id])
  end

  def update
    @agency = Agency.find(params[:id])
    respond_to do |format|
      if @agency.update_attributes(params.require(:agency).permit!)
        flash[:notice] = "You have successfully updated portal (#{@agency.name})"
        format.html { redirect_to :action => "index" }
      else
        error_catching_and_flashing(@agency)
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    message = "Deleting an agency will cause major percussions.
               So it is advisable not to delete agency. However,
               if you really want to delete it then please ask your administrator"
    logger.info(message)
    flash[:notice] = message
    redirect_to :back
  end

  def error_catching_and_flashing(object)
    unless object.valid?
      object.errors.each{ |mesg|
        logger.info(mesg)
      }
    end
  end
end

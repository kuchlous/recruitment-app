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
        flash[:success] = "Created agency: #{@agency.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@agency)
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
        flash[:success] = "Updated agency: #{@agency.name}"
        format.html { redirect_to :action => "index" }
      else
        log_errors(@agency)
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    message = "Deleting an agency will cause major percussions.
               So it is advisable not to delete agency. However,
               if you really want to delete it then please ask your administrator"
    flash[:warning] = message
    redirect_back(fallback_location: root_path)
  end

end

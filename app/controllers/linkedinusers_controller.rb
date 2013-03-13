class LinkedinusersController < ApplicationController
  # GET /linkedinusers/1
  # GET /linkedinusers/1.json
  def show
    @linkedinuser = Linkedinuser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @linkedinuser }
    end
  end

  def show_connections
    @linkedinusers = Linkedinuser.all
  end
end

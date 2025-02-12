class ApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id] || params[:application_id])
    @pets = Pet.search(params[:name]) if params[:name]
    if params[:pet_id]
      @application.pets << Pet.find(params[:pet_id])
      @application.save
      redirect_to "/applications/#{@application.id}"
    elsif params[:description]
      @application.update(description: params[:description], application_status: "Pending")
      @application.save
      redirect_to "/applications/#{@application.id}"
    end
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(post_params)
    @application.application_status = "In Progress"
    if @application.save
      redirect_to action: 'index'
    else
      flash[:error] = "Error: #{error_message(@application.errors)}"
      redirect_to "/applications/new"
    end
  end

  private

  def post_params
    params.permit(:name_of_applicant, :street_address, :city, :state, :zip_code, :description, :shelter_id, :application_id, :name)
  end
end

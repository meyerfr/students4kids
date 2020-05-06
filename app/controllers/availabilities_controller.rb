class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_sitter

  def index
    @availabilities = Availability.where(status == 'available' && sitter == current_user)
    @availability = Availability.new
  end

  def create
    @availabilities = Availability.where(status == 'available' && sitter == current_user)
    @availability = Availability.new()
    @availability.sitter = current_user
    @availability.start_time = DateTime.parse("#{availability_params[:date]} #{availability_params[:start_time]} +0200")
    @availability.end_time = DateTime.parse("#{availability_params[:date]} #{availability_params[:end_time]} +0200")

    respond_to do |format|
      if @availability.save
        format.html { redirect_to availabilities_url, notice: 'Availability was successfully created.' }
        format.json { render :index, status: :created, location: @availability }
      else
        format.html { render :index }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @availability.start_time = DateTime.parse("#{availability_params[:date]} #{availability_params[:start_time]} +0200")
    @availability.end_time = DateTime.parse("#{availability_params[:date]} #{availability_params[:end_time]} +0200")
    respond_to do |format|
      if @availability.save
        format.html { redirect_to availabilities_url, notice: 'Availability was successfully updated.' }
        format.json { render :index, status: :ok, location: @availability }
      else
        @availability.errors.full_messages.each do |error|
          print(error)
        end
        format.html { render :edit }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @availability.destroy
    respond_to do |format|
      format.html { redirect_to availabilities_url, notice: 'Availability was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_availability
    @availability = Availability.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def availability_params
    params.permit(:start_time, :end_time, :date)
  end

  # Check whether current user is a sitter
  def authenticate_sitter
    redirect_to root_path unless current_user.is_role?('sitter')
  end
end
class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i(show edit update destroy)

  def index
    @availabilities = Availability.where(status == "available")
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    @availability.sitter = current_user

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
    respond_to do |format|
      if @availability.update(availability_params)
        format.html { redirect_to availabilities_url, notice: 'Availability was successfully updated.' }
        format.json { render :index, status: :ok, location: @availability }
      else
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
    params.require(:availability).permit(:start_time, :end_time, :status)
  end
end

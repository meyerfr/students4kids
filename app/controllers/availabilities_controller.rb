class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_sitter!

  AVAILABILITIES_PER_PAGE = 10

  def index
    @page = params.fetch(:page, 0).to_i
    @page_count = page_counter
    @availabilities = Availability
                          .order(
                              :start_time
                          )
                          .where(
                              "sitter_id = :id AND start_time >= :start AND status = :status",
                              id: current_user.id,
                              start: DateTime.current,
                              status: 'available'
                          )
                          .offset(
                              @page * AVAILABILITIES_PER_PAGE
                          )
                          .limit(
                              AVAILABILITIES_PER_PAGE
                          )
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(
        sitter: current_user,
        start_time: DateTime.parse("#{availability_params[:date]} #{availability_params[:start_time]} +0200"),
        end_time: DateTime.parse("#{availability_params[:date]} #{availability_params[:end_time]} +0200")
    )

    respond_to do |format|
      if @availability.save
        format.html { redirect_to availabilities_path, notice: 'Availability was successfully created.' }
      else
        format.html { redirect_to availabilities_path, notice: 'Availability could not be created, please try again.' }
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
        format.html { redirect_to availabilities_path, notice: 'Availability was successfully updated.' }
      else
        format.html { redirect_to availabilities_path, notice: 'Availability could not be updated, please try again.' }
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
  def authenticate_sitter!
    redirect_to root_path unless current_user.is_role?('sitter')
  end

  def page_counter
    Availability.where(
        "sitter_id = :id AND start_time >= :start AND status = :status",
        id: current_user.id,
        start: DateTime.current,
        status: 'available'
    ).count / AVAILABILITIES_PER_PAGE
  end
end
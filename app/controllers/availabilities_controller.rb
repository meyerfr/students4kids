class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_sitter!

  def index
    availabilities_per_page = 10
    @page = params.fetch(:page, 0).to_i
    @page_count = page_counter(availabilities_per_page)
    @availabilities = future_user_availabilities
                          .order(
                              :start_time
                          )
                          .offset(
                              @page * availabilities_per_page
                          )
                          .limit(
                              availabilities_per_page
                          )
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(
        sitter: current_user,
        start_time: DateTime.parse("#{availability_params[:date]}T#{availability_params[:start_time]}+02:00"),
        end_time: DateTime.parse("#{availability_params[:date]}T#{availability_params[:end_time]}+02:00")
    )

    if @availability.save
      redirect_to availabilities_path, notice: 'Availability was successfully created.'
    else
      redirect_to availabilities_path, notice: 'Availability could not be created, please try again.'
    end
  end

  def edit
  end

  def update
    @availability.start_time = DateTime.parse("#{availability_params[:date]}T#{availability_params[:start_time]}+02:00")
    @availability.end_time = DateTime.parse("#{availability_params[:date]}T#{availability_params[:end_time]}+02:00")
    if @availability.save
      redirect_to availabilities_path, notice: 'Availability was successfully updated.'
    else
      redirect_to availabilities_path, notice: 'Availability could not be updated, please try again.'
    end
  end

  def destroy
    @availability.destroy
    redirect_to availabilities_url, notice: 'Availability was successfully deleted.'
  end

  private
  def future_user_availabilities
    Availability.where(
        "sitter_id = :id AND start_time >= :start AND status = :status",
        id: current_user.id,
        start: DateTime.current,
        status: 'available'
    )
  end

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

  def page_counter(availabilities_per_page)
    future_user_availabilities.count / availabilities_per_page
  end
end
class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_sitter!

  def index
    page_items = 10
    @page = params.fetch(:page, 0).to_i
    @page_count = page_counter(page_items)

    @availability = Availability.new
    @availabilities = future_user_availabilities
                          .order(:start_time)
                          .offset(@page * page_items)
                          .limit(page_items)
  end

  def create
    @availability = Availability.new(
        sitter: current_user,
        start_time: parse_date_time(availability_params[:date], availability_params[:start_time]),
        end_time: parse_date_time(availability_params[:date], availability_params[:end_time])
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
    @availability.start_time = parse_date_time(availability_params[:date], availability_params[:start_time])
    @availability.end_time = parse_date_time(availability_params[:date], availability_params[:end_time])

    if @availability.save
      redirect_to availabilities_path, notice: 'Availability was successfully updated.'
    else
      redirect_to availabilities_path, notice: 'Availability could not be updated, please try again.'
    end
  end

  def destroy
    @availability.destroy
    redirect_to availabilities_path, notice: 'Availability was successfully deleted.'
  end

  private

  def parse_date_time(date, time)
    DateTime.parse("#{date}T#{time}+02:00")
  end

  def future_user_availabilities
    Availability.where(
        "sitter_id = :id AND start_time >= :start AND status = :status",
        id: current_user.id,
        start: DateTime.current,
        status: 'available'
    )
  end

  def set_availability
    @availability = Availability.find(params[:id])
  end

  def availability_params
    params.permit(:start_time, :end_time, :date)
  end

  def page_counter(page_items)
    future_user_availabilities.count / page_items
  end
end

class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_sitter!

  def index
    page_items = 10
    @page = params.fetch(:page, 0).to_i
    @page_count = page_counter(page_items)

    @availability = Availability.new
    @availabilities = paginate(future_user_availabilities, @page, page_items)

  end

  def create
    @availability = Availability.new(
        sitter: current_user,
        start_time: parse_date_time(
            availability_params[:date],
            availability_params[:start_time]
        ),
        end_time: parse_date_time(
            availability_params[:date],
            availability_params[:end_time]
        )
    )

    if @availability.save
      index_redirect('Availability was successfully created.')
    else
      index_redirect('Availability could not be created, please try again.')
    end
  end

  def edit
  end

  def update
    @availability.start_time = parse_date_time(
        availability_params[:date],
        availability_params[:start_time]
    )
    @availability.end_time = parse_date_time(
        availability_params[:date],
        availability_params[:end_time]
    )

    if @availability.save
      index_redirect('Availability was successfully updated.')
    else
      index_redirect('Availability could not be updated, please try again.')
    end
  end

  def destroy
    @availability.destroy
    index_redirect('Availability was successfully deleted.')
  end

  private

  def index_redirect(notice)
    redirect_to availabilities_path, notice: notice
  end

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

  def authenticate_sitter!
    redirect_to root_path unless current_user.is_role?('sitter')
  end

  def paginate(availabilities, page, page_items)
    availabilities
        .order(:start_time)
        .offset(page * page_items)
        .limit(page_items)
  end

  def page_counter(page_items)
    future_user_availabilities.count / page_items.to_f
  end
end
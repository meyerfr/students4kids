class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_sitter!

  def index
    page_items = 10
    @page = params.fetch(:page, 0).to_i
    @page_count = count_pages(page_items)

    @availability = Availability.new
    @availabilities = paginate_availabilities(get_user_availabilities, @page, page_items)

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
      redirect_to_index('Availability was successfully created.')
    else
      redirect_to_index('Availability could not be created, please try again.')
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
      redirect_to_index('Availability was successfully updated.')
    else
      redirect_to_index('Availability could not be updated, please try again.')
    end
  end

  def destroy
    @availability.destroy
    redirect_to_index('Availability was successfully deleted.')
  end

  private

  def redirect_to_index(notice)
    redirect_to availabilities_path, notice: notice
  end

  def parse_date_time(date, time)
    DateTime.parse("#{date}T#{time}+02:00")
  end

  def get_user_availabilities
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

  def paginate_availabilities(availabilities, page, page_items)
    availabilities
        .order(:start_time)
        .offset(page * page_items)
        .limit(page_items)
  end

  def count_pages(page_items)
    get_user_availabilities.count / page_items.to_f
  end
end
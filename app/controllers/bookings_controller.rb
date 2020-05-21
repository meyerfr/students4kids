class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:create] do |action|
    action.authenticate_parent!(bookings_path)
  end
  before_action :set_booking, only: %i(:confirm_booking :decline_booking)

  def index
    # set future_bookings & past_bookings
    if current_user.is_role?('parent')
      future_bookings = current_user.parent_bookings.select { |b| b.availability.start_time >= DateTime.current }
      past_bookings = current_user.parent_bookings.select { |b| b.availability.start_time < DateTime.current }
    elsif current_user.is_role?('sitter')
      future_bookings = current_user.sitter_bookings.select { |b| b.availability.start_time >= DateTime.current }
      past_bookings = current_user.sitter_bookings.select { |b| b.availability.start_time < DateTime.current }
    end

    @bookings_pending = future_bookings.select { |booking| booking.is_status?('pending') }
    @bookings_confirmed = future_bookings.select { |booking| booking.is_status?('confirmed') }
    @bookings_past = past_bookings.select { |booking| booking.is_status?('confirmed') }
  end

  def create
    @booking = current_user.parent_bookings.new(booking_params)
    if @booking.save
      ActiveRecord::Base.connection.exec_query("CALL update_availability ('#{params[:start_time]}', '#{params[:end_time]}', #{@booking.availability.id})")
      redirect_to bookings_path, notice: 'Booking was successfully created.'
    else
      redirect_to bookings_path, notice: 'Booking could not be created. Please try again'
    end
  end

  def confirm_booking
    if @booking.update(status: 'confirmed')
      redirect_to bookings_path
    else
      redirect_to :root
    end
  end

  def decline_booking
    if @booking.update(status: 'declined')
      redirect_to bookings_path
    else
      redirect_to :root
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:sitter_id, :parent_id, :status, :availability_id)
  end
end

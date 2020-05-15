class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_parent!, only: [:create]
  before_action :set_booking, only: [:confirm_booking, :decline_booking]

  def index
    future_bookings = Booking.select{|booking| booking.availability.start_time >= DateTime.current}
    past_bookings = Booking.select{|booking| booking.availability.start_time < DateTime.current}

    if current_user.is_role?('parent')
      future_bookings = future_bookings.select{|booking| booking.parent == current_user}
      past_bookings = past_bookings.select{|booking| booking.parent == current_user}
    elsif current_user.is_role?('sitter')
      future_bookings = future_bookings.select{|booking| booking.sitter == current_user}
      past_bookings = past_bookings.select{|booking| booking.sitter == current_user}
    end
    @bookings_pending = future_bookings.select{|booking| booking.status == 'pending'}
    @bookings_confirmed = future_bookings.select{|booking| booking.status == 'confirmed'}
    @bookings_past = past_bookings.select{|booking| booking.status == 'confirmed'}
  end

  def create
    @booking = current_user.parent_bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        ActiveRecord::Base.connection.exec_query("CALL update_availability ('#{params[:start_time]}', '#{params[:end_time]}', #{@booking.availability.id})")
        format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
      else
        format.html { redirect_to bookings_path, notice: 'Booking could not be created. Please try again' }
      end
    end
  end

  def confirm_booking
    Booking.find(params[:id]).update(status: "confirmed")
    redirect_to bookings_path
  end

  def decline_booking
    Booking.find(params[:id]).update(status: "declined")
    redirect_to bookings_path
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:sitter_id, :parent_id, :status, :availability_id)
  end

  def authenticate_parent!
    redirect_to bookings_path unless current_user.is_role?('parent')
  end
end

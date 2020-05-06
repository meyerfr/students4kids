class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_parent!, only: [:new, :create]
  before_action :set_booking, only: [:edit, :update, :destroy]

  def index
    bookings_all = Booking.all
    if current_user.is_role?('parent')
      bookings = bookings_all.where(parent: current_user)
    elsif current_user.is_role?('sitter')
      bookings = bookings_all.where(sitter: current_user)
    else
      bookings = bookings_all.all
    end
    @bookings_pending = bookings.where(status: 'pending')
    @bookings_confirmed = bookings.where(status: 'confirmed')
    @bookings_declined = bookings.where(status: 'declined')
  end

  def create
    @booking = current_user.parent_bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        start = Time.parse(params[:start_time])
        end_time = Time.parse(params[:end_time])
        ActiveRecord::Base.connection.exec_query("CALL update_availability (\"#{params[:start_time]}\", \"#{params[:end_time]}\", #{@booking.availability.id})")
        format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
        format.json { render :index, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_booking
    Booking.find(params[:id]).update(status: 'confirmed')
    redirect_to bookings_path
  end

  def decline_booking
    Booking.find(params[:id]).update(status: 'declined')
    redirect_to bookings_path
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:sitter_id, :parent_id, :start_time, :end_time, :status, :availability_id)
  end

  def authenticate_parent!
    redirect_to bookings_path unless current_user.is_role?('parent')
  end
end

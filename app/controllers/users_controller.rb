class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:sitters]
  before_action only: [:sitters] do |action|
    action.authenticate_parent!(user_path(current_user))
  end
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_correct_user!, only: [:edit, :update, :destroy]

  SITTERS_PER_PAGE = 10

  def sitters
    set_time_queries
    @page = params.fetch(:page, 0).to_i
    @page_count = count_pages(@start_time_query, @end_time_query)
    @sitters = get_available_sitters(@start_time_query, @end_time_query)
                   .offset(@page * SITTERS_PER_PAGE)
                   .limit(SITTERS_PER_PAGE)
  end

  def show
    @access_to_see_all_details = check_read_access
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, notice: 'Oops something went wrong.'
    end
  end

  def destroy
    @user.destroy
    redirect_to :root, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :dob, :phone, :bio, :role, :address, :longitude, :latitude)
  end

  # currently not disabled
  def get_sitters_inside_radius
    @sitters = helpers.all_sitters.select(&:geocoded?)
    @sitters.select { |s| s.distance_to(current_user) <= s.radius }
  end

  def verify_correct_user!
    return if current_user == @user

    flash.alert = "You don't have the rights for this action"
    redirect_to bookings_path
  end

  def set_time_queries
    if params[:start_time].present? && params[:end_time].present?
      @start_time_query = Time.parse("#{params[:date]} #{params[:start_time]}")
      @end_time_query = Time.parse("#{params[:date]} #{params[:end_time]}")
    else
      @start_time_query = Time.parse("#{Date.tomorrow} 10:00")
      @end_time_query = Time.parse("#{Date.tomorrow} 16:00")
    end
  end

  def get_available_sitters(start_time_query, end_time_query)
    Availability.where(
        "start_time <= :parent_start_time AND end_time >= :parent_end_time AND status = :status",
        parent_start_time: start_time_query,
        parent_end_time: end_time_query,
        status: 'available'
    )
  end

  def count_pages(start_time_query, end_time_query)
    get_available_sitters(start_time_query, end_time_query).count / SITTERS_PER_PAGE
  end

  def check_read_access
    current_user == @user || current_user.is_role?('admin') || current_user.sitters.select{ |sitter| sitter.id == @user.id }.present? || current_user.parents.select{ |parent| parent.id == @user.id }.present?
  end
end

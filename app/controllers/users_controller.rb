class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:sitters]
  before_action :authenticate_parent!, only: [:sitters]
  before_action :set_user, only: %i(show edit update destroy)
  before_action :only_correct_user!, only: [:edit, :update, :destroy]

  SITTERS_PER_PAGE = 10

  # GET /sitters
  def sitters
    set_time_queries
    @page = params.fetch(:page, 0).to_i
    @page_count = page_counter(@start_time_query, @end_time_query)
    @sitters = Availability
                   .joins(:sitter)
                   .where(
                       "start_time <= :start_time_query AND end_time >= :end_time_query AND status = :status",
                       start_time_query: @start_time_query,
                       end_time_query: @end_time_query,
                       status: 'available'
                   )
                   .offset(@page * SITTERS_PER_PAGE)
                   .limit(SITTERS_PER_PAGE)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @access_to_see_all_details = check_read_access
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, notice: 'Oops something went wrong.'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to :root, notice: 'User was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :dob, :phone, :bio, :role, :address, :longitude, :latitude)
  end

  def sitters_inside_radius
    @sitters = helpers.all_sitters.select(&:geocoded?)
    @sitters.select { |s| s.distance_to(current_user) <= s.radius }
  end

  def authenticate_parent!
    return if current_user.is_role?('parent')

    redirect_to current_userd
  end

  def only_correct_user!
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

  def page_counter(start_time_query, end_time_query)
    Availability
        .where(
            "start_time <= :parent_start_time AND end_time >= :parent_end_time AND status = :status",
            parent_start_time: start_time_query,
            parent_end_time: end_time_query,
            status: 'available'
        ).count / SITTERS_PER_PAGE
  end

  def check_read_access
    current_user == @user || current_user.is_role?('admin') || current_user.sitters.select{ |sitter| sitter.id == @user.id }.present? || current_user.parents.select{ |parent| parent.id == @user.id }.present?
  end
end

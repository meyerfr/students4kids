class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy)

  # GET /users
  # GET /users.json
  def index
    @sitters = sitters_inside_radius
    @users = User.geocoded

    @markers = @sitters.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        infoWindow: render_to_string(partial: 'info_window', locals: { user: user }),
        image_url: helpers.asset_url('hand-print-red.png')
      }
    end
  end

  # GET /sitters
  def sitters
    @start_time_query = params[:start_time].present? ? params[:start_time] : "#{Date.tomorrow}T10:00"
    @end_time_query = params[:end_time].present? ? params[:end_time] : "#{Date.tomorrow}T16:00"
    @sitters = sitters_with_availabilities(@start_time_query..@end_time_query)
    # raise
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  def sitters_with_availabilities(parent_timerange)
    sitters = []
    sitters_inside_radius.select do |sitter|
      sitter.availabilities.each do |availability|
        if availability.is_status?('available') && (availability.start_time..availability.end_time).cover?(parent_timerange)
          sitters << { sitter: sitter, availability: availability }
        end
      end
    end
    sitters
  end
end

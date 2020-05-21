class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  # def after_sign_in_path_for(resource)
  # end

  ['sitter', 'parent'].each do |role|
    define_method("authenticate_#{role}!") do |*fallback_path|
      return if current_user.is_role?(role)

      if fallback_path.present?
        redirect_to fallback_path
      else
        root_path
      end
    end
  end

  # def authenticate_parent!(fallback_location)
  #   return if current_user.is_role?('parent')

  #   redirect_to fallback_location
  # end

  # def authenticate_sitter!(fallback_location)
  #   return if current_user.is_role?('sitter')

  #   redirect_to fallback_location
  # end
end

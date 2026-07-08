class ApplicationController < ActionController::Base
  helper_method :current_user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def current_user
    # Temporary override to get around not having a proper login system
    # NOTE: Authentication is intentionally simplified for this exercise
    # In a production system this would likely use Devise with role-based authorisation
    email = params[:as] == "lawyer" ? "lawyer@example.com" : "client@example.com"
    @current_user ||= User.find_by!(email:)
  end
end

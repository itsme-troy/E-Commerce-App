class ApplicationController < ActionController::Base
  include Authentication
  before_action :set_current_user 

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user  # so I can use it in views too

  def require_admin
    unless current_user&.role == "admin"
      redirect_to root_path, alert: "Admins only!"
    end
  end

  helper_method :current_user

  def current_user
    Current.user
  end
  
  private 

  def set_current_user
    if session[:user_id]
        Current.user = User.find_by(id: session[:user_id])
    end
  end

end

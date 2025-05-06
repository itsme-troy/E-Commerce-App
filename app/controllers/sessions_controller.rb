# Handles Login/Logout (Authentication)
# Manages user sessions — specifically, signing in and signing out.
 # It does not create new users.

class SessionsController < ApplicationController
  # Guests are allowed to access the sign-up form and submit registration
  skip_before_action :require_authentication, only: [:new, :create]

  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def start_new_session_for(user)
    return if user.nil?
  
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end
 
  def new
  end

  def create
    # custom authentication
    # checks user credentials
    if user = User.authenticate_by(params.permit(:email_address, :password))
      # if valid, start new session logs the user in
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Account created and logged in!"
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  # logs the user out
  def destroy
    terminate_session
    redirect_to new_session_path
  end
end


# defines a controller named 'UserController' 
# inherit from application controller to access rails controller features (like `params`, `session`, `redirect_to`, etc.).
class UsersController < ApplicationController
    
# Guests are allowed to access the sign-up form and submit registration.
skip_before_action :require_authentication, only: [:new, :create]

  # action to display registration form 
  # initialize a new empty User object (@user) that the form will bind to 
  def new
    @user = User.new

  end

  # Action triggered when the registration form is submitted.
  # Creates a new 'User' instance with form data filtered 
  # by the 'user_params' method (to prevent mass assignment vulnerabilities).
  def create
    @user = User.new(user_params)
    # attempts to save the user to the database if it passes validation
    if @user.save

      # Stores the newly created user’s ID in the `session`, 
      session[:user_id] = @user.id  # auto-login after registration

      # redirect to the homepage and success message 
      redirect_to root_path, notice: "Account created successfully!"
    else
      # if saving failed, (e.g invalid input), display the registration form again
      # display form error or Unprocessable Entity status
      render :new, status: :unprocessable_entity
    end
  end

  # following methods are not accessible as actions from routes.
  private

  # requires email, password, confirmation and role 
  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :role)
  end

end

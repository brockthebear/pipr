class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # Verify that user has signed up (i.e., exists in database).
    if user && user.authenticate(params[:session][:password])
      # Verify that user has activated account
      if user.activated?
        log_in user
        # Remember or forget user's permanent session. 
        params[:session][:remember_me] == '1' ? remember(user) : forget(user) 
        # Take user to user's own profile page
        redirect_back_or user
      else
        # Render error message if user has signed up but not activated account.
        message =  "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        # Take user back to home page of app
        redirect_to root_url
      end
    else  
      # Supply error message detailing all the ways that they have ever failed.
      flash.now[:danger] = 'Invalid email/password combination'
      # Re-render the new user form
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url 
  end

end

class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Congratulations! Account activated! Click on the 'Home' tab to the right to get started!"
      redirect_to user
    else 
      flash[:danger] = "Oh no! It appears that your activation link is not valid."
      redirect_to root_url
    end 
  end

end

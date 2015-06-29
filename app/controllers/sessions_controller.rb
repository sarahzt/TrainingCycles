class SessionsController < ApplicationController
  layout "home"

  def new
    render '_new'
  end

  def create
    # create a new session (after user registers or logs in)
    user = User.authenticate(session_params[:email],session_params[:password])

    if user
      flash[:notice] = "You've been logged in with Training Cycles."
      # run helper method to log in user
      log_in(user)
      # continue on with Google authentication (Oauth)
      redirect_to :new_google_login
    else
      error_string = "No matching user found. If you haven't already done so, <a href='/users/new' class='alert-link'>please register</a>."
      flash[:error] = error_string 
      # go back to log-in form
      # redirect_to :back
      redirect_to new_session_path
    end
  end

  def destroy
    # possible save all user info into a user key, like [:user][:id], so we can easily clear out key?
    log_out
    flash[:notice] = "You've successfully logged out of Training Cycles."
    # redirect to root page
    redirect_to :new_session
  end

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
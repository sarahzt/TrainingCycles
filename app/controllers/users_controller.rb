class UsersController < ApplicationController
  layout "register"

  def new
    # display create new user view (registration)
    render '_new'
  end

  def create
    # create a new user account (registration)
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Your account has been registered. Welcome to the Training Cycles! Please login below"
      
      # redirect to create new session method (log-in)
      redirect_to :new_session
    else
      # loop through errors and save to error_string
      @error_string = ''
      @user.errors.full_messages.each do |message|
          @error_string += message + '. '
      end
      
      # save errors to flash
      flash[:error] =  @error_string  

      # go back to registration form
      redirect_to :back
    end    
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

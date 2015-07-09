class SessionsController < ApplicationController
  skip_before_action :user_logged_in, only: [:new, :create]
  
  def new  
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user
  		remember user
      # render text: params
      flash[:success] = "Login successfuly"
  		redirect_to categories_path
  	else
      # render text: params
  		flash[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
	log_out if logged_in?
	redirect_to login_path		
  end

end

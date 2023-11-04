class SessionsController < ApplicationController

  def new
  end

  def create
    # To create a new session for user (logging in), we need to do 3 things
    # 1. Authenticate the user: check if the submitted email and password corresponds to an existing user in the database
    # 2. Put the user id into the session hash 
    # 3. Redirect to the user's profile and send along the session hash in a cookie
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to session[:intended_url] || user #, notice: "Welcome back, #{user.name}"
      session[:intended_url] = nil
    else
      flash.now[:alert] = "Invalid email and password combination. Please, try again!"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to events_url, status: :see_other, notice: "You are now signed out!"
  end

end

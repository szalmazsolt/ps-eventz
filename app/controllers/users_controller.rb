class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @liked_events = @user.liked_events
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Account successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # the require_correct_user method sets @user, so we do not need to set it again in the action
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to events_url, alert: "Account deleted", status: :see_other
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end

  def require_correct_user
    @user = User.find(params[:id])
    unless correct_user?(@user)
      redirect_to events_url
    end
  end



end

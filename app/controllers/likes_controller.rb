class LikesController < ApplicationController
  before_action :require_signin

  def create
    @event = Event.find_by!(slug: params[:event_id])
    @event.likes.create!(user: current_user)
    redirect_to @event
  end

  def destroy
    # fail
    like = current_user.likes.find(params[:id])
    like.destroy
    redirect_to event_path(params[:event_id])
  end

end

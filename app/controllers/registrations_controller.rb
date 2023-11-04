class RegistrationsController < ApplicationController

  before_action :require_signin
  before_action :setup_event

  def index
    @registrations = @event.registrations
  end

  def new
    @registration = @event.registrations.new
  end

  def create
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user

    if @registration.save
      redirect_to event_registrations_url(@event), notice: "You successfully registered for '#{@event.name}'"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @registration = @event.registrations.find(params[:id])
  end

  def update
    @registration = @event.registrations.find(params[:id])

    if @registration.update(registration_params)
      redirect_to event_registrations_url, notice: "Your registration has been successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @registration = @event.registrations.find(params[:id])
    @registration.destroy
    redirect_to event_registrations_url, notice: "Your registration has been deleted", status: :see_other
  end

  private

    def registration_params
      params.require(:registration).permit(:how_heard)
    end

    def setup_event
      @event = Event.find_by!(slug: params[:event_id])
    end
end

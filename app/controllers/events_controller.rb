class EventsController < ApplicationController

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    case params[:filter]
    when "upcoming"
      @events = Event.upcoming
    when "past"
      @events = Event.past
    when "recent"
      @events = Event.recent
    when "free"
      @events = Event.free
    else
      @events = Event.all
    end
  end

  def show
    @likers = @event.likers
    @categories = @event.categories  
    
    if current_user
      # this code queries the likes table where the user id equals the id of the currently signed in user and the event id equals the id of the id of the event in the url params
      # so @like will either be a like object or nil
      @like = current_user.likes.find_by(event_id: @event.id)
    end

  end

  def edit
  end

  def update    
    if @event.update(event_params)
      flash[:notice] = "Event successfully updated"
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event successfully created"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    @event.destroy

    # we need to change the HTTP verb from delete' back to 'get'
    # for this, we use the see_other alias, which stands for 303 status
    redirect_to events_url, status: :see_other
  end

  private

    def event_params
      params
        .require(:event)
        .permit(:name, :description, :location, :price, :starts_at, :image_file_name, :capacity, category_ids: [])
    end

    def set_event
      @event = Event.find_by!(slug: params[:id])
    end

end

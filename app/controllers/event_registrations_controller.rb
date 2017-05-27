class EventRegistrationsController < ApplicationController
  before_action :authorize_user!

  def index
    render json: {events: current_user.events.order('start_time DESC')}
  end

  def create
    current_user.event_registrations.create! event_id: params[:event_id]

    head :no_content
  end

end

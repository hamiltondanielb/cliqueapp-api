class EventRegistrationsController < ApplicationController
  before_action :authorize_user!

  def index
    render json: {events: ActiveModelSerializers::SerializableResource.new(current_user.events.order('start_time DESC'))}
  end

  def create
    current_user.event_registrations.create! event_id: params[:event_id]

    head :no_content
  end

  def destroy
    event_registration = current_user.event_registrations.find_by(event_id: params[:event_id])
    event_registration.destroy! if event_registration.present?

    head :no_content
  end

end

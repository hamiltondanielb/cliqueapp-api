class EventRegistrationsController < ApplicationController
  before_action :authorize_user!

  def index
    render json: {events: ActiveModelSerializers::SerializableResource.new(current_user.events.order('start_time DESC'))}
  end

  def create
    event = Event.find params[:event_id]

    if !event.free?
      begin
        processor = PaymentProcessor.new
        current_user.update! stripe_customer_id: processor.create_customer(params[:stripe_info][:email], params[:stripe_info][:id]).id
        processor.charge event.price.to_i, current_user.stripe_customer_id, "acct_1APr3BLdGggRtZJo"
      rescue Exception => e
        return render json: {errors: {global: "We could not process the payment: #{e}"}}
      end
    end

    current_user.event_registrations.create! event_id: params[:event_id]

    head :no_content
  end

  def destroy
    event_registration = current_user.event_registrations.find_by(event_id: params[:event_id])
    event_registration.destroy! if event_registration.present?

    head :no_content
  end

end

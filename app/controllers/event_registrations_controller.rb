class EventRegistrationsController < ApplicationController
  before_action :authorize_user!

  def index
    render json: {events: ActiveModelSerializers::SerializableResource.new(current_user.active_events.order('start_time DESC'))}
  end

  def create
    event = Event.find params[:event_id]

    if !event.free?
      begin
        processor = PaymentProcessor.new
        current_user.update! stripe_customer_id: processor.create_customer(params[:stripe_info][:email], params[:stripe_info][:id]).id
        charge = processor.charge event.price.to_i, current_user.stripe_customer_id
        current_user.event_registrations.create! event_id: params[:event_id], charge_id: charge.id, amount_paid: charge.amount
      rescue Exception => e
        return render json: {errors: {global: "We could not process the payment: #{e}"}}
      end
    else
      current_user.event_registrations.create! event_id: params[:event_id]
    end

    head :no_content
  end

  def destroy
    event_registration = current_user.event_registrations.active.find_by(event_id: params[:event_id])

    if event_registration.incurred_charge?
      PaymentProcessor.new.refund event_registration.charge_id
      event_registration.update! refunded_at: Time.now, cancelled_at: Time.now
    else
      event_registration.update! cancelled_at: Time.now
    end

    head :no_content
  end

end

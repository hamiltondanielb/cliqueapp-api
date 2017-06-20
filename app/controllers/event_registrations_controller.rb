class EventRegistrationsController < ApplicationController
  before_action :authorize!

  def index
    return render(json: {errors: {global: 'Please specify a date'}}, status:400) if params[:date].blank?

    range_start = Time.parse(params[:date]) - 1.minute
    events = current_user.active_events.within_24_hours_of(range_start).order('start_time DESC')

    render json: {posts: ActiveModelSerializers::SerializableResource.new(events.map(&:post))}
  end

  def days_with_event_registrations
    return render(json: {errors: {global: 'Please specify a start date'}}, status:400) if params[:seven_weeks_from].blank?

    days = current_user.active_events.within_seven_weeks_from(Time.parse(params[:seven_weeks_from])).pluck(:start_time)

    render json: {days: days}
  end

  def create
    event = Event.find params[:event_id]
    charge = OpenStruct.new id:nil, amount:nil

    if !event.free?
      begin
        processor = PaymentProcessor.new
        current_user.update! stripe_customer_id: processor.create_customer(params[:stripe_info][:email], params[:stripe_info][:id]).id
        charge = processor.charge event.price.to_i, current_user.stripe_customer_id
      rescue Exception => e
        Rails.logger.warn "Could not charge user: #{e}"
        return render json: {errors: {global: "We could not process the payment: #{e}"}}
      end
    end

    current_user.event_registrations.create! event_id: params[:event_id], charge_id: charge.id, amount_paid: charge.amount

    head :no_content
  end

  def destroy
    event_registration = current_user.event_registrations.active.find_by(event_id: params[:event_id])

    if !event_registration.incurred_charge?
      event_registration.update! cancelled_at: Time.now
      return head :no_content
    end

    if !event_registration.cancellable?
      return render json: {errors: {global: "This event registration cannot be cancelled."}}
    end

    begin
      refund = PaymentProcessor.new.refund event_registration.charge_id
    rescue Exception => e
      Rails.logger.warn "Could not refund user: #{e}"
      return render json: {errors: {global: "We could not process the payment: #{e}"}}
    end

    event_registration.update! refunded_at: Time.now, cancelled_at: Time.now, refund_id: refund.id

    head :no_content
  end

end

class UserMailer < ApplicationMailer
  include ApplicationHelper

  def notify_of_cancellation event_registration

    @event_registration = event_registration
    @user = event_registration.user

    prepare_variables
    mail(to: @user.email, subject: "OpenLesson: An event was cancelled")
  end

  def congratulate_on_becoming_instructor user

    @user = user

    prepare_variables
    mail(to: @user.email, subject: "OpenLesson: Congratulations on becoming an instructor")
  end

  def inform_of_payout event
    @user = event.post.user
    @event = event

    prepare_variables
    mail(to: @user.email, subject: "OpenLesson: You received a new payout")
  end

  private
  def prepare_variables
    @logo_data_uri = asset_data_uri 'logo.png'
  end
end

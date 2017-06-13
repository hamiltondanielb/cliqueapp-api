class CancellationNotificationMailer < ApplicationMailer
  include ApplicationHelper

  def notify_of_cancellation event_registration

    @event_registration = event_registration
    @user = event_registration.user
    @logo_data_uri = asset_data_uri 'logo.png'

    mail(to: @user.email, subject: "OpenLesson: An event was cancelled")
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/cancellation_notification_mailer
class CancellationNotificationMailerPreview < ActionMailer::Preview

  def notify_of_cancellation
    CancellationNotificationMailer.notify_of_cancellation EventRegistration.last
  end
end

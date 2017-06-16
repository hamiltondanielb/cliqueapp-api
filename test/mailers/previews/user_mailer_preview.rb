# Preview all emails at http://localhost:3000/rails/mailers/
class UserMailerPreview < ActionMailer::Preview

  def notify_of_cancellation
    UserMailer.notify_of_cancellation EventRegistration.last
  end

  def congratulate_on_becoming_instructor
    UserMailer.congratulate_on_becoming_instructor User.last
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/
class UserMailerPreview < ActionMailer::Preview
  def notify_of_cancellation
    UserMailer.notify_of_cancellation EventRegistration.last
  end

  def congratulate_on_becoming_instructor
    UserMailer.congratulate_on_becoming_instructor User.last
  end

  def inform_of_payout
    e = Event.last
    e.assign_attributes paid_out_at:Time.now, payout_id: "1234532", payout_currency:"jpy", payout_sum:210
    UserMailer.inform_of_payout e
  end
end

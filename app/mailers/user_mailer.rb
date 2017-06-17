class UserMailer < ApplicationMailer
  include ApplicationHelper

  def notify_of_cancellation event_registration

    @event_registration = event_registration
    @user = event_registration.user

    mail(to: @user.email, subject: I18n.t('email.subject.event_cancelled'))
  end

  def congratulate_on_becoming_instructor user

    @user = user

    mail(to: @user.email, subject: I18n.t('email.subject.congratulate_on_becoming_instructor'))
  end

  def inform_of_payout event
    @user = event.post.user
    @event = event

    mail(to: @user.email, subject: I18n.t('email.subject.payout_received'))
  end

end

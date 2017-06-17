class UserMailer < ApplicationMailer
  include ApplicationHelper

  def notify_of_cancellation event_registration

    @event_registration = event_registration
    @user = event_registration.user

    prepare_variables
    mail(to: @user.email, subject: I18n.t('email.subject.event_cancelled'))
  end

  def congratulate_on_becoming_instructor user

    @user = user

    prepare_variables
    mail(to: @user.email, subject: I18n.t('email.subject.congratulate_on_becoming_instructor'))
  end

  def inform_of_payout event
    @user = event.post.user
    @event = event

    prepare_variables
    mail(to: @user.email, subject: I18n.t('email.subject.payout_received'))
  end

  private
  def prepare_variables
    @logo_data_uri = asset_data_uri 'logo.png'
  end
end

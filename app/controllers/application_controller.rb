class ApplicationController < ActionController::Base
  include OptionsController

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :set_locale

  def test_locale
  end

  protected

  def set_locale
    I18n.locale = params[:locale] || accept_locale(request.env) || I18n.default_locale
    I18n.locale = I18n.default_locale unless I18n.available_locales.include?(I18n.locale)
    headers['Content-Language'] = I18n.locale unless headers['Content-Language']
  end

  def authorize_user!
    if !signed_in?
      render json: {error: 'You need to be signed in to access this resource'}, status: 403
    end
  end

  private

  def accept_locale(env)
    accept_langs = env["HTTP_ACCEPT_LANGUAGE"]
    return if accept_langs.nil?

    languages_and_qvalues = accept_langs.split(",").map { |l|
      l += ';q=1.0' unless l =~ /;q=\d+(?:\.\d+)?$/
      l.split(';q=')
    }

    lang = languages_and_qvalues.sort_by { |(locale, qvalue)|
      qvalue.to_f
    }.last.first

    lang == '*' ? nil : lang
  end
end

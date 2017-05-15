class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :set_locale

  def test_locale
  end

  protected

  def set_locale
    I18n.locale = params[:locale] || accept_locale(request.env) || I18n.default_locale
    I18n.locale = I18n.default_locale unless I18n.available_locales.include?(I18n.locale)
    headers['Content-Language'] = I18n.locale unless headers['Content-Language']
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

class ApplicationController < ActionController::Base
  include OptionsController

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :set_locale

  def test_locale
  end

  protected

  def using_postgresql?
    ActiveRecord::Base.connection.adapter_name.downcase == "postgresql"
  end

  def set_locale
    I18n.locale = params[:locale] || accept_locale(request.env) || I18n.default_locale
    I18n.locale = I18n.default_locale unless I18n.available_locales.include?(I18n.locale)
    headers['Content-Language'] = I18n.locale unless headers['Content-Language']
  end

  def authorize!
    if !signed_in?
      render json: {errors: {global: 'You need to be signed in to access this resource'}}, status: 403
    elsif !current_user.confirmed?
      render json: {errors: {global: 'You need to confirm your account before performing this action'}}, status: 401
    end
  end

  def errors_hash_for model
    { errors: model.errors.map {|k,v| [k, v]}.to_h }
  end

  def current_user
    begin
      super
    rescue ActiveRecord::RecordNotFound
      nil
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

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :switch_locale

  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { lang: I18n.locale }
  end

  private

  def switch_locale
    I18n.locale = I18n.locale_available?(params[:lang]) && params[:lang] ||
                  I18n.default_locale
  end
end

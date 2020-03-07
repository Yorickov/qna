class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :switch_locale
  before_action :gon_user, unless: :devise_controller?

  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { lang: I18n.locale }
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  # check_authorization unless: :devise_controller?

  private

  def switch_locale
    I18n.locale = I18n.locale_available?(params[:lang]) && params[:lang] ||
                  I18n.default_locale
  end

  def gon_user
    gon.user_id = current_user&.id
  end
end

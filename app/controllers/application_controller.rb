class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit

  before_action :switch_locale
  before_action :gon_user, unless: :devise_controller?

  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { lang: I18n.locale }
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def switch_locale
    I18n.locale = I18n.locale_available?(params[:lang]) && params[:lang] ||
                  I18n.default_locale
  end

  def gon_user
    gon.user_id = current_user&.id
  end

  def user_not_authorized
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'You are not authorized to perform this action' }
      format.any { render status: :forbidden, plain: 'Access denied' }
    end
  end
end

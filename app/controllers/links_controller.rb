class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user_is_link_author!

  def destroy
    link.destroy
  end

  private

  def link
    @link ||= params[:id] ? Link.find(params[:id]) : Link.new
  end

  helper_method :link

  def ensure_current_user_is_link_author!
    resource = link.linkable
    return if current_user.author_of?(resource)

    redirect_to root_path, notice: t('.wrong_author')
  end
end

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link, only: :destroy

  def destroy
    authorize @link

    @link.destroy
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end
end

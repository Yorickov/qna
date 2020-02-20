class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    resource = @link.linkable
    if current_user.author_of?(resource)
      @link.destroy
    else
      redirect_to root_path, notice: t('.wrong_author')
    end
  end
end

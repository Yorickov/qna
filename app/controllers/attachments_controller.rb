class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user_is_attachment_author!

  def destroy
    attachment.purge
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment

  def ensure_current_user_is_attachment_author!
    resource = attachment.record
    return if current_user.author_of?(resource)

    redirect_to root_path, notice: t('.wrong_author')
  end
end

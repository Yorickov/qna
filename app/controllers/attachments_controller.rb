class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: :destroy

  def destroy
    authorize @attachment

    @attachment.purge
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end

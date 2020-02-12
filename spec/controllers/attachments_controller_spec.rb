# rubocop:disable Metrics/BlockLength

require 'rails_helper'

describe AttachmentsController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, :with_files, user: user1) }

  describe 'DELETE #destroy' do
    context 'as authorized Author' do
      before { login(user1) }

      it 'deletes his attached file' do
        expect { delete :destroy, params: { id: question.files.first, format: :js } }
          .to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question.files.first, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'as authorized no Author' do
      before { login(user2) }

      it 'does not delete not his attached file' do
        expect { delete :destroy, params: { id: question.files.first, format: :js } }
          .to_not change(ActiveStorage::Attachment, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question.files.first, format: :js }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      let!(:user2_question) { user2.questions.first }

      it 'does not delete not his attached file' do
        expect { delete :destroy, params: { id: question.files.first, format: :js } }
          .to_not change(ActiveStorage::Attachment, :count)
      end

      it 'redirects to new session' do
        delete :destroy, params: { id: question.files.first, format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end
end

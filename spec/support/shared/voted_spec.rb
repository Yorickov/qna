require 'rails_helper'

shared_examples 'voted' do
  let(:controller) { described_class }
  let(:model) { controller.controller_name.classify.constantize }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:votable) { create(model.to_s.underscore.to_sym, user: user2) }

  describe 'PATCH #vote_up' do
    context 'as authorized no votable Author' do
      before { login(user1) }

      it 'assigns the requested votable to @votable' do
        patch :vote_up, params: { id: votable, format: :json }
        expect(assigns(:votable)).to eq votable
      end

      it 'changes votable attribute' do
        original_rating = votable.rating
        patch :vote_up, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(original_rating + 1)
      end

      it 'try to vote twice' do
        original_rating = votable.rating
        patch :vote_up, params: { id: votable, format: :json }
        patch :vote_up, params: { id: votable }, format: :json
        votable.reload

        expect(votable.rating).to eq(original_rating + 1)
      end

      it 'changes votes count' do
        expect { patch :vote_up, params: { id: votable, format: :json } }
          .to change(Vote, :count).by 1
      end

      it 'renders json' do
        patch :vote_up, params: { id: votable, format: :json }

        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as authorized votable Author' do
      before { login(user2) }

      it 'does not update the votable' do
        original_rating = votable.rating
        patch :vote_up, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'does not change votes count' do
        expect { patch :vote_up, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        patch :vote_up, params: { id: votable, format: :json }

        expect(response.status).to eq 403
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as Guest' do
      it 'does not update the votable' do
        original_rating = votable.rating
        patch :vote_up, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'does not change votes count' do
        expect { patch :vote_up, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        patch :vote_up, params: { id: votable, format: :json }

        expect(response.status).to eq 401
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'as authorized no votable Author' do
      before { login(user1) }

      it 'assigns the requested votable to @votable' do
        patch :vote_down, params: { id: votable, format: :json }
        expect(assigns(:votable)).to eq votable
      end

      it 'changes votable attribute' do
        original_rating = votable.rating
        patch :vote_down, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(original_rating - 1)
      end

      it 'try to vote twice' do
        original_rating = votable.rating
        patch :vote_down, params: { id: votable, format: :json }
        patch :vote_down, params: { id: votable }, format: :json
        votable.reload

        expect(votable.rating).to eq(original_rating - 1)
      end

      it 'changes votes count' do
        expect { patch :vote_down, params: { id: votable, format: :json } }
          .to change(Vote, :count).by 1
      end

      it 'renders json' do
        patch :vote_down, params: { id: votable, format: :json }

        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as authorized votable Author' do
      before { login(user2) }

      it 'does not update the votable' do
        original_rating = votable.rating
        patch :vote_down, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'does not change votes count' do
        expect { patch :vote_down, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        patch :vote_down, params: { id: votable, format: :json }

        expect(response.status).to eq 403
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as Guest' do
      it 'does not update the votable' do
        original_rating = votable.rating
        patch :vote_down, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'does not change votes count' do
        expect { patch :vote_down, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        patch :vote_down, params: { id: votable, format: :json }

        expect(response.status).to eq 401
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end
  end

  describe 'DELETE #vote_reset' do
    let!(:vote) { create(:vote, votable: votable, user: user1) }
    before { votable.update(rating: 1) }

    context 'as authorized no votable Author' do
      before { login(user1) }

      it 'updates the votable' do
        original_rating = votable.rating
        delete :vote_reset, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq(original_rating - 1)
      end

      it 'deletes the vote' do
        expect { delete :vote_reset, params: { id: votable, format: :json } }
          .to change(Vote, :count).by(-1)
      end

      it 'renders json' do
        delete :vote_reset, params: { id: votable, format: :json }

        expect(response.status).to eq 200
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as authorized votable Author' do
      before { login(user2) }

      it 'does not update the votable' do
        original_rating = votable.rating
        delete :vote_reset, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'does not delete the vote' do
        expect { delete :vote_reset, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        delete :vote_reset, params: { id: votable, format: :json }

        expect(response.status).to eq 403
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end

    context 'as Guest' do
      it 'does not update the votable' do
        original_rating = votable.rating
        delete :vote_reset, params: { id: votable, format: :json }
        votable.reload

        expect(votable.rating).to eq original_rating
      end

      it 'did not to delete the vote' do
        expect { delete :vote_reset, params: { id: votable, format: :json } }
          .not_to change(Vote, :count)
      end

      it 'gets forbidden response and renders json' do
        delete :vote_reset, params: { id: votable, format: :json }

        expect(response.status).to eq 401
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end
    end
  end
end

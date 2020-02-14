# rubocop:disable Metrics/BlockLength

require 'rails_helper'

describe AnswersController, type: :controller do
  let(:user1) { create(:user_with_questions) }
  let(:user2) { create(:user_with_questions) }
  let(:user1_question) { user1.questions.first }

  describe 'POST #create' do
    context 'as User' do
      before { login(user1) }

      context 'with valid attributes' do
        def trigger
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer),
            format: :js
          }
        end

        it 'saves a new answer in the database' do
          expect { trigger }.to change(Answer, :count).by(1)
        end

        it 'saves as the answer of correct question' do
          trigger
          created_answer = Answer.order(:created_at).last

          expect(created_answer.question).to eq(user1_question)
        end

        it 'saves as the answer of correct user' do
          trigger
          created_answer = Answer.order(:created_at).last

          expect(created_answer.user).to eq(user1)
        end

        it 'redirects to show view' do
          trigger

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        def trigger
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end

        it 'does not save the answer' do
          expect { trigger }.not_to change(Answer, :count)
        end

        it 're-renders new view' do
          trigger

          expect(response).to render_template :create
        end
      end
    end

    context 'as Guest' do
      def trigger
        post :create, params: {
          question_id: user1_question,
          answer: attributes_for(:answer),
          format: :js
        }
      end

      it 'does not save the answer' do
        expect { trigger }.not_to change(Answer, :count)
      end

      it 'no-authenticate response' do
        trigger

        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: user1_question, user: user1) }

    context 'as authorized Author' do
      before { login(user1) }

      context 'with valid attributes' do
        before { patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } }

        it 'assigns the requested answer to @answer' do
          answer.reload

          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }
        end

        it 'does not change answer attributes' do
          original_body = answer.body
          answer.reload

          expect(answer.body).to eq original_body
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'as no authorized Author' do
      before { login(user2) }
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, body: 'new body'),
          format: :js
        }
      end

      it 'does not update the answer' do
        original_body = answer.body
        answer.reload

        expect(answer.body).to eq original_body
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      before do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, body: 'new body'),
          format: :js
        }
      end

      it 'does not update the answer' do
        original_body = answer.body
        answer.reload

        expect(answer.body).to eq original_body
      end

      it 'no-authenticate response' do
        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: user1_question, user: user1) }

    context 'as authorized Author' do
      before { login(user1) }

      def trigger
        delete :destroy, params: { id: answer, format: :js }
      end

      it 'deletes the answer' do
        expect { trigger }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        trigger

        expect(response).to render_template :destroy
      end
    end

    context 'as authorized no Author' do
      before { login(user2) }

      def trigger
        delete :destroy, params: { id: answer, format: :js }
      end

      it 'does not delete the answer' do
        expect { trigger }.to_not change(Answer, :count)
      end

      it 'redirects to root' do
        trigger

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      def trigger
        delete :destroy, params: { id: answer, format: :js }
      end

      it 'does not delete the answer' do
        expect { trigger }.to_not change(Answer, :count)
      end

      it 'no-authenticate response' do
        trigger

        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end

  describe 'PATCH #choose_best' do
    let!(:answer1) { create(:answer, question: user1_question, user: user1) }
    let!(:answer2) { create(:answer, question: user1_question, user: user2) }

    context 'as authorized Author' do
      before { login(user1) }

      def trigger
        patch :choose_best, params: { id: answer2, format: :js }
      end

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          trigger
          answer2.reload

          expect(assigns(:answer)).to eq answer2
        end

        it 'changes answer attributes' do
          trigger
          answer2.reload

          expect(answer2).to be_best
        end

        it 'swap value best attribute' do
          answer1.update(best: true)
          trigger
          [answer1, answer2].each(&:reload)

          expect(answer2).to be_best
          expect(answer1).not_to be_best
        end

        it 'renders update view' do
          trigger

          expect(response).to render_template :choose_best
        end
      end
    end

    context 'as no authorized Author' do
      before { login(user2) }
      before { patch :choose_best, params: { id: answer2, format: :js } }

      it 'does not update the answer' do
        original_body = answer2.body
        answer2.reload

        expect(answer2.body).to eq original_body
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      before { patch :choose_best, params: { id: answer2, format: :js } }

      it 'does not update the answer' do
        original_body = answer2.body
        answer2.reload

        expect(answer2.body).to eq original_body
      end

      it 'no-authenticate response' do
        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end
end

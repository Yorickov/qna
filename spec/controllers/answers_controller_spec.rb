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
        it 'saves a new answer in the database' do
          expect do
            post :create, params: {
              question_id: user1_question,
              answer: attributes_for(:answer),
              format: :js
            }
          end
            .to change(Answer, :count).by(1)
        end

        it 'saves as the answer of correct question' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer),
            format: :js
          }

          created_answer = Answer.order(:created_at).last

          expect(created_answer.question).to eq(user1_question)
        end

        it 'redirects to show view' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer),
            format: :js
          }

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create, params: {
              question_id: user1_question,
              answer: attributes_for(:answer, :invalid),
              format: :js
            }
          end
            .not_to change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer, :invalid),
            format: :js
          }

          expect(response).to render_template :create
        end
      end
    end

    context 'as Guest' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer),
            format: :js
          }
        end
          .not_to change(Answer, :count)
      end

      it 'no-authenticate response' do
        post :create, params: {
          question_id: user1_question,
          answer: attributes_for(:answer),
          format: :js
        }

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
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload

          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update,
                  params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          end
            .to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

          expect(response).to render_template :update
        end
      end
    end

    context 'as no authorized Author' do
      before { login(user2) }

      it 'does not update the answer' do
        expect do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, body: 'new body'),
            format: :js
          }
        end
          .to_not change(answer, :body)
      end

      it 'redirects to root' do
        patch :update, params: {
          id: answer,
          answer: attributes_for(:answer, body: 'new body'),
          format: :js
        }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'does not update the answer' do
        expect do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, body: 'new body'),
            format: :js
          }
        end
          .to_not change(answer, :body)
      end

      it 'no-authenticate response' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, body: 'new body'), format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: user1_question, user: user1) }

    context 'as authorized Author' do
      before { login(user1) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }
          .to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'as authorized no Author' do
      before { login(user2) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }
          .to_not change(Answer, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }
          .to_not change(Answer, :count)
      end

      it 'no-authenticate response' do
        delete :destroy, params: { id: answer, format: :js }

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

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :choose_best, params: { id: answer2, format: :js }
          answer2.reload

          expect(assigns(:answer)).to eq answer2
        end

        it 'assigns the current best answer to @answer' do
          answer1.update(best: true)
          patch :choose_best, params: { id: answer2, format: :js }
          [answer1, answer2].each(&:reload)

          expect(assigns(:current_best_answer)).to eq answer1
        end

        it 'changes answer attributes' do
          patch :choose_best, params: { id: answer2, format: :js }
          answer2.reload

          expect(answer2.best).to be true
        end

        it 'swap value best attribute' do
          answer1.update(best: true)
          patch :choose_best, params: { id: answer2, format: :js }
          [answer1, answer2].each(&:reload)

          expect(answer2.best).to be true
          expect(answer1.best).to be false
        end

        it 'renders update view' do
          patch :choose_best, params: { id: answer2, format: :js }

          expect(response).to render_template :choose_best
        end
      end
    end

    context 'as no authorized Author' do
      before { login(user2) }

      it 'does not update the answer' do
        expect { patch :choose_best, params: { id: answer2, format: :js } }
          .to_not change(answer2, :best)
      end

      it 'redirects to root' do
        patch :choose_best, params: { id: answer2, format: :js }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'does not update the answer' do
        expect { patch :choose_best, params: { id: answer2, format: :js } }
          .to_not change(answer2, :best)
      end

      it 'no-authenticate response' do
        patch :choose_best, params: { id: answer2, format: :js }

        expect(response.status).to eq 401
        expect(response.body).to eq t('devise.failure.unauthenticated')
      end
    end
  end
end

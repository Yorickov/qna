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
              answer: attributes_for(:answer)
            }
          end
            .to change(Answer, :count).by(1)
        end

        it 'saves as the answer of correct question' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer)
          }
          created_answer = Answer.order(:created_at).last

          expect(created_answer.question).to eq(user1_question)
        end

        it 'redirects to show view' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer)
          }
          created_answer = Answer.order(:created_at).last

          expect(response).to redirect_to created_answer.question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create, params: {
              question_id: user1_question,
              answer: attributes_for(:answer, :invalid)
            }
          end
            .to change(Answer, :count).by(0)
        end

        it 're-renders new view' do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer, :invalid)
          }

          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'as Guest' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: user1_question,
            answer: attributes_for(:answer)
          }
        end
          .to change(Answer, :count).by(0)
      end

      it 'redirects to new session' do
        post :create, params: {
          question_id: user1_question,
          answer: attributes_for(:answer)
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: user1_question, user: user1) }

    context 'as authorized Author' do
      before { login(user1) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }
          .to change(Answer, :count).by(-1)
      end

      it 'redirects to show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end

    context 'as authorized no Author' do
      before { login(user2) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'redirects to new session' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

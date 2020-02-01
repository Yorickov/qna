require 'rails_helper'

describe AnswersController, type: :controller do
  let(:user) { build(:user_with_questions) }
  let(:no_author) { build(:user) }

  describe 'POST #create' do
    let(:answer) { create(:answer) }
    let(:question) { user.questions.first }

    context 'as User' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect do
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer)
            }
          end
            .to change(Answer, :count).by(1)
        end

        it 'saves as the answer of correct question' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(Answer.order(:created_at).last.question).to eq(question)
        end

        it 'redirects to show view' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid)
            }
          end
            .to change(Answer, :count).by(0)
        end

        it 're-renders new view' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid)
          }

          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'as Guest' do
      it 'redirects to new session' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid)
        }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) do
      create(:answer, question: user.questions.first, user: user)
    end

    context 'as authorized Author' do
      before { login(user) }

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
      it 'redirects to root' do
        login(no_author)

        delete :destroy, params: { id: answer }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'redirects to new session' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

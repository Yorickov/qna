require 'rails_helper'

describe AnswersController, type: :controller do
  let(:user) { build(:user_with_questions) }

  describe 'POST #create' do
    let(:answer) do
      create(:answer, question: user.questions.first, author: user)
    end

    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: {
            question_id: user.questions.first,
            answer: attributes_for(:answer)
          }
        end
          .to change(Answer, :count).by(1)
      end

      it 'saves as the answer of correct question' do
        post :create, params: {
          question_id: user.questions.first,
          answer: attributes_for(:answer)
        }

        expect(Answer.last.question).to eq(user.questions.first)
      end

      it 'redirects to show view' do
        post :create, params: {
          question_id: user.questions.first,
          answer: attributes_for(:answer)
        }

        expect(response).to redirect_to user.questions.first
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: user.questions.first,
            answer: attributes_for(:answer, :invalid)
          }
        end
          .to change(Answer, :count).by(0)
      end

      it 're-renders new view' do
        post :create, params: {
          question_id: user.questions.first,
          answer: attributes_for(:answer, :invalid)
        }

        expect(response).to render_template 'questions/show'
      end
    end
  end
end

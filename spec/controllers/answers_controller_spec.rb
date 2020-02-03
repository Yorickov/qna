require 'rails_helper'

describe AnswersController, type: :controller do
  let(:user) { build(:user_with_questions) }

  describe 'POST #create' do
    let(:answer) { create(:answer) }
    let(:question) { user.questions.first }

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

  describe 'DELETE #destroy' do
    let!(:answer) do
      create(:answer, question: user.questions.first, user: user)
    end

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
end

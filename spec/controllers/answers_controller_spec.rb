require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers) }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answer) { question.answers.first }

    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }
        end
          .to change(Answer, :count).by(4)
      end

      it 'saves as the answer of correct question' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer)
        }

        expect(Answer.last.question_id).to eq(question.id)
      end

      it 'redirects to show view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer)
        }

        expect(response).to redirect_to assigns(:answer)
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
          .to change(Answer, :count).by(3)
      end

      it 're-renders new view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid)
        }

        expect(response).to render_template :new
      end
    end
  end
end

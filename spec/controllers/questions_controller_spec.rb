# rubocop:disable Metrics/BlockLength

require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:user1) { build(:user_with_questions) }
  let(:user2) { build(:user) }
  let(:user1_question) { user1.questions.first }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(user1.questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: user1_question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq user1_question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'as User' do
      before { login(user1) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'as Guest' do
      it 'redirect to new session' do
        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question, user: user1) }

    context 'as User' do
      before { login(user1) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }
            .to change(Question, :count).by(1)
        end

        it 'saves as the question of correct user' do
          post :create, params: { question: attributes_for(:question) }

          expect(Question.order(:created_at).last.user).to eq(user1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }

          expect(response).to redirect_to user1.questions.last
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }
            .to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }

          expect(response).to render_template :new
        end
      end
    end

    context 'as Guest' do
      it 'redirects to new session' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as authorized Author' do
      before { login(user1) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: user1_question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: user1_question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'as authorized no Author' do
      it 'redirects to root' do
        login(user2)

        delete :destroy, params: { id: user1_question }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'redirects to new session' do
        delete :destroy, params: { id: user1_question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

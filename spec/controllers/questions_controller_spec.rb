require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:user) { build(:user_with_questions) }
  let(:no_author) { build(:user) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(user.questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: user.questions.first } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq user.questions.first
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'as User' do
      before { login(user) }
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
    let(:question) { create(:question, user: user) }

    context 'as User' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }
            .to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }

          expect(response).to redirect_to user.questions.last
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
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: user.questions.first } }
          .to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: user.questions.first }
        expect(response).to redirect_to questions_path
      end
    end

    context 'as authorized no Author' do
      it 'redirects to root' do
        login(no_author)

        delete :destroy, params: { id: user.questions.first }

        expect(response).to redirect_to root_path
      end
    end

    context 'as Guest' do
      it 'redirects to new session' do
        delete :destroy, params: { id: user.questions.first }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

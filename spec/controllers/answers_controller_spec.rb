require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid answer' do
      it 'can save a new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count).by(1)
      end

      it 'answer belongs to the user who is created it' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(user).to be_author_of(assigns(:answer))
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid answer' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
          .not_to change(Answer, :count)
      end

      it 're-renders questions show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to render_template 'questions/show'
      end
    end
  end
end

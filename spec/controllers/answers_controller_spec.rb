require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  describe 'POST #create' do
    context 'when answer is valid' do
      it 'saves a new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to question_answers_path(assigns(:answer))
      end
    end

    context 'when answer is invalid' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
          .not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to render_template :new
      end
    end
  end
end
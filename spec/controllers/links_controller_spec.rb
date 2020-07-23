require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:link) { create(:link, :of_question, linkable: question) }

  describe 'DELETE #destroy' do
    context 'when authenticated user is author' do
      before { login(question.author) }

      it 'can delete a link from the database' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when authenticated user is not an author' do
      before { login(other_user) }

      it 'cannot delete a link from the database' do
        expect { delete :destroy, params: { id: link }, format: :js }.not_to change(Link, :count)
      end

      it 'responses with http status :forbidden' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when unauthenticated user' do
      it 'cannot delete a link from the database' do
        expect { delete :destroy, params: { id: link } }.not_to change(Link, :count)
      end

      it 'responses with http status :unauthorized' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

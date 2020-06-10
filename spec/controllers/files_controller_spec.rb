require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let!(:file1) { fixture_file_upload(Rails.root.join('spec/rails_helper.rb')) }
  let!(:file2) { fixture_file_upload(Rails.root.join('spec/spec_helper.rb')) }

  describe 'DELETE #destroy' do
    context "when question's author" do
      let!(:question) { create(:question, author: user, files: [file1, file2]) }

      before { login(user) }

      it 'can delete his own file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when unauthenticated user' do
      let!(:question) { create(:question, author: user, files: [file1]) }

      it 'tries to delete file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .not_to change(ActiveStorage::Attachment, :count)
      end

      it 'response status 401' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status 401
      end
    end

    context "when non-author's question" do
      let!(:question) { create(:question, author: user, files: [file1]) }

      before { login(user1) }

      it 'tries to delete not his own file' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }
          .not_to change(ActiveStorage::Attachment, :count)
      end

      it 'renders template destroy ' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end

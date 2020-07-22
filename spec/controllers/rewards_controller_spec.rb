require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:questions) { create_list(:question, 2, :with_reward, author: user) }

    before do
      questions.each { |question| question.reward&.update!(user: other_user) }

      login(other_user)
      get :index
    end

    it "assigns all user's rewards to the questions" do
      expect(assigns(:rewards)).to match_array other_user.rewards
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:rewards) }
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:question1) { create(:question, author: user1) }

    it 'user is an author' do
      expect(user).to be_author_of(question)
    end

    it 'user is not an author' do
      expect(user).not_to be_author_of(question1)
    end
  end

  describe '#add_reward' do
    let(:user) { create(:user) }
    let(:user1) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:reward) { create(:reward, question: question) }

    it "increases the amount of user's rewards by one" do
      expect { question.reward&.update!(user: user1) }.to change(user1.rewards, :count).by(1)
    end

    it 'adds reward to user' do
      question.reward&.update!(user: user1)

      expect(user1.rewards.last).to eq reward
    end
  end
end

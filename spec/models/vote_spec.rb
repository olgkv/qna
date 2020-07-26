require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }

  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validations' do
    let(:vote) { create(:vote, :for_question, user: user) }

    it { should validate_presence_of :value }
    it { should validate_inclusion_of(:value).in_range(-1..1) }

    it {
      expect(vote).to validate_uniqueness_of(:user)
        .scoped_to(:votable_id, :votable_type)
    }
  end
end

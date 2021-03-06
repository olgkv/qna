require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable', :question

  describe 'relationships' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:author).class_name(:User) }
    it { should have_one(:reward).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#reward?' do
    let(:user) { create(:user) }
    let(:question_with_reward) { create(:question, :with_reward, author: user) }
    let(:question_without_reward) { create(:question, author: user) }

    it 'returns true if question with reward' do
      expect(question_with_reward).to be_reward
    end

    it 'returns false if question without reward' do
      expect(question_without_reward).not_to be_reward
    end
  end
end

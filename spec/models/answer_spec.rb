require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable', :answer

  describe 'relationships' do
    it { should belong_to :question }
    it { should belong_to(:author).class_name(:User) }

    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'best answer validation if the answer is choosen as the best' do
    let!(:answer) { create(:answer, best: true) }

    it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe 'best answer validation if the answer is not choosen as best answer' do
    let!(:answer) { create(:answer, best: false) }

    it { should_not validate_uniqueness_of(:best).scoped_to(:question_id) }
  end

  describe '#set_best' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, :with_reward, author: user) }
    let!(:question1) { create(:question, :with_reward, author: user) }
    let!(:answer1) { create(:answer, best: true, question: question, author: user) }
    let!(:answer2) { create(:answer, best: false, question: question, author: other_user) }
    let!(:answer3) { create(:answer, best: false, question: question, author: user2) }
    let!(:answer4) { create(:answer, best: false, question: question1, author: user2) }

    before do
      answer2.set_best
      answer1.reload
      answer2.reload
      answer3.reload
    end

    it 'set best answer' do
      expect(answer2).to be_best
    end

    it 'does not set best answer to others answers' do
      expect(answer1).not_to be_best
      expect(answer3).not_to be_best
    end

    it 'adds reward to author of best answer' do
      expect(other_user.rewards.first).to eq question.reward
    end

    it 'does not change rewards of the author if answer already was the best' do
      expect { answer2.set_best }.not_to change(other_user.rewards, :count)
    end

    it "changes rewards of the author if answer wasn't the best" do
      expect { answer4.set_best }.to change(user2.rewards, :count).by(1)
    end
  end
end

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'relationships' do
    it { should belong_to :question }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to(:author).class_name(:User) }

    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it { should accept_nested_attributes_for :links }
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
    let!(:question) { create(:question, author: user) }
    let!(:answer1) { create(:answer, best: true, question: question) }
    let!(:answer2) { create(:answer, best: false, question: question) }
    let!(:answer3) { create(:answer, best: false, question: question) }

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
  end
end

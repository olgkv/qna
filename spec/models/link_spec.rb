require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'relationships' do
    it { should belong_to :linkable }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end

  describe '#gist_link?' do
    let(:question) { create(:question) }
    let(:gist_link) { create(:link, linkable: question, url: 'https://gist.github.com/JoshCheek/84e32487050fad765a3894a810e747c8') }
    let(:another_link) { create(:link, linkable: question, url: 'https://dev.to') }

    it 'returns true if link is a gist link' do
      expect(gist_link).to be_gist_link
    end

    it 'returns false if user is not an author of the resource' do
      expect(another_link).not_to be_gist_link
    end
  end
end

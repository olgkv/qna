require 'rails_helper'

shared_examples_for 'votable' do |resource_name|
  describe 'relationships' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  let!(:user) { create(:user) }
  let!(:resource) { create(resource_name) }

  describe '#vote_up' do
    it 'votes up by valid user for the resource' do
      resource.vote_up(user)
      expect(resource.votes.first.user).to eq user
    end

    it 'increases by 1 the votes of the resource' do
      resource.vote_up(user)
      expect(resource.votes.first.value).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'votes down by valid user for the resource' do
      resource.vote_down(user)
      expect(resource.votes.first.user).to eq user
    end

    it 'decreases by 1 the votes of the resource' do
      resource.vote_down(user)
      expect(resource.votes.first.value).to eq(-1)
    end
  end

  describe '#amount_of_votes' do
    it 'is equal to 0 when there is no votes' do
      expect(resource.amount_of_votes).to eq(0)
    end

    it 'increases by vote up' do
      expect { resource.vote_up(user) }.to change(resource, :amount_of_votes).by(1)
    end

    it 'decreases by vote down' do
      expect { resource.vote_down(user) }.to change(resource, :amount_of_votes).by(-1)
    end
  end

  describe '#votes?' do
    it 'is true when a user votes up' do
      resource.vote_up(user)
      expect(resource.votes?).to be true
    end

    it 'is true when a user votes down' do
      resource.vote_down(user)
      expect(resource.votes?).to be true
    end

    it 'is false when nobody votes' do
      expect(resource.votes?).to be false
    end
  end
end

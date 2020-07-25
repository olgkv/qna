require 'rails_helper'
shared_examples_for 'voted' do |resource_name|
  let(:user) { create(:user) }

  describe 'POST #vote_up' do
    before do
      login(user)
    end

    context 'when valid user who is allowed to vote' do
      let!(:resource) { create(resource_name) }

      it 'votes up the resource' do
        expect { post(:vote_up, params: { id: resource.id }) }.to change(resource, :amount_of_votes).by(1)
      end

      it 'responces JSON' do
        post(:vote_up, params: { id: resource.id })
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it 'responces JSON of specific format' do
        post(:vote_up, params: { id: resource.id })

        expect(response.body).to eq({ id: resource.id, amount: resource.amount_of_votes, type: resource.class.name }.to_json)
      end
    end

    context 'when invalid user who is not allowed to vote' do
      let!(:resource_by_user) { create(resource_name, author: user) }

      it 'does not vote up the question' do
        expect { post(:vote_up, params: { id: resource_by_user.id }) }.not_to change(resource_by_user, :amount_of_votes)
      end

      it 'answers with unprocessible_entity(422)' do
        post(:vote_up, params: { id: resource_by_user.id })
        expect(response.status).to eq 422
      end
    end
  end

  describe 'POST #vote_down' do
    before do
      login(user)
    end

    context 'when valid user is allowed to vote' do
      let!(:resource) { create(resource_name) }

      it 'votes  down the resource' do
        expect { post(:vote_down, params: { id: resource.id }) }.to change(resource, :amount_of_votes).by(-1)
      end

      it 'answers back JSON' do
        post(:vote_down, params: { id: resource.id })

        expect(response.header['Content-Type']).to include 'application/json'
      end

      it 'answers back JSON of specified format' do
        post(:vote_down, params: { id: resource.id })

        expect(response.body).to eq({ id: resource.id, amount: resource.amount_of_votes, type: resource.class.name }.to_json)
      end

      context 'when invalid user who is not allowed to vote' do
        let!(:resource_by_user) { create(resource_name, author: user) }

        it 'does not downvote the question' do
          expect { post(:vote_down, params: { id: resource_by_user.id }) }.not_to change(resource_by_user, :amount_of_votes)
        end

        it 'answers with unprocessible_entity(422)' do
          post(:vote_up, params: { id: resource_by_user.id })
          expect(response.status).to eq 422
        end
      end
    end

    describe 'DELETE #vote_cancel' do
      before { login(user) }

      context 'when valid user who is allowed to vote' do
        let!(:resource) { create(resource_name) }

        before do
          post(:vote_up, params: { id: resource.id })
        end

        it 'deletes the previous vote by the user' do
          expect { delete(:vote_cancel, params: { id: resource.id }) }
            .to change(resource.votes, :count).by(-1)
        end

        it 'answers with JSON' do
          delete(:vote_cancel, params: { id: resource.id })
          expect(response.header['Content-Type']).to include 'application/json'
        end

        it 'answers back with JSON of correct format' do
          delete(:vote_cancel, params: { id: resource.id })
          resource.reload
          expect(response.body).to eq({ id: resource.id, amount: resource.amount_of_votes, type: resource.class.name }.to_json)
        end
      end

      context 'when invalid user who is not allowed to vote' do
        let!(:resource_by_user) { create(resource_name, author: user) }

        it 'does not delete the previous vote by the user' do
          expect { delete(:vote_cancel, params: { id: resource_by_user.id }) }.not_to change(resource_by_user.votes, :count)
        end

        it 'answers with unprocessible_entity(422)' do
          post(:vote_up, params: { id: resource_by_user.id })
          expect(response.status).to eq 422
        end
      end
    end
  end
end

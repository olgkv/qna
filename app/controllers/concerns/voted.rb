module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_resource, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    if @resource.votable_by?(current_user)
      @resource.vote_up(current_user)

      render json: votes_json
    else
      head :unprocessable_entity
    end
  end

  def vote_down
    if @resource.votable_by?(current_user)
      @resource.vote_down(current_user)
      render json: votes_json
    else
      head :unprocessable_entity
    end
  end

  def vote_cancel
    if @resource.vote_by_user(current_user)
      @resource.vote_by_user(current_user).destroy
      render json: votes_json
    else
      head :unprocessable_entity
    end
  end
end

def set_resource
  @resource = controller_name.classify.constantize.find(params[:id])
end

def votes_json
  { id: @resource.id, amount: @resource.amount_of_votes, type: @resource.class.name }
end

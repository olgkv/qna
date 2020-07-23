class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy]

  def destroy
    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      head :forbidden
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end

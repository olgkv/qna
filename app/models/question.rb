class Question < ApplicationRecord
  include Linkable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def reward?
    reward.present?
  end
end

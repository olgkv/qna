class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def reward?
    reward.present?
  end
end

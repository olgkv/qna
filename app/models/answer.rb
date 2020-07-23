class Answer < ApplicationRecord
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  validates :best, uniqueness: { scope: :question_id }, if: :best?

  scope :best, -> { order(best: :desc) }

  def set_best
    transaction do
      question.answers.best&.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: author)
    end
  end
end

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many_attached :files

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end

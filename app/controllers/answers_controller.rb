class AnswersController < ApplicationController
  expose :question, shallow_child: :answer
  expose :answer, shallow_parent: :question
  expose :answers, from: :question

  def create
    answer = question.answers.new(answer_params)

    if answer.save
      redirect_to question_answers_path(answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

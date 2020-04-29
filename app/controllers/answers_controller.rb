class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_answers_path(@answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end

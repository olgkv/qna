class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer was successfully created'
    else
      render :new
    end
  end

  def new
    @answer = @question.answers.new
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end

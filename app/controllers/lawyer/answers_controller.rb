module Lawyer
  class AnswersController < ApplicationController
    def create
      @question = Question.find(params[:question_id])
      @answer = @question.answers.build(answer_params)
      @answer.lawyer = current_user
      @answer.paid = false

      if @answer.save
        respond_to do |format|
          format.html do
            redirect_to lawyer_question_path(@question, as: "lawyer"),
                        notice: "Answer submitted and payment request sent."
          end

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "question_answers",
              partial: "lawyer/questions/answers",
              locals: { question: @question.reload }
            )
          end
        end
      else
        render "lawyer/questions/show", status: :unprocessable_entity
      end
    end

    private

    def answer_params
      params.require(:answer).permit(:response_text, :proposed_fee_pence)
    end
  end
end
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
            redirect_to lawyer_questions_path(as: "lawyer"),
                        notice: "Answer submitted and payment request sent."
          end
        end
      else
        respond_to do |format|
          format.html { render "lawyer/questions/show", status: :unprocessable_content }
          format.turbo_stream { render "lawyer/questions/show", status: :unprocessable_content }
        end
      end
    end

    private

    def answer_params
      params.require(:answer).permit(:response_text, :proposed_fee_pounds)
    end

    def check_user_is_lawyer
      unless current_user&.lawyer?
        redirect_to root_path, alert: "You must be a lawyer to submit an answer."
      end
    end
  end
end

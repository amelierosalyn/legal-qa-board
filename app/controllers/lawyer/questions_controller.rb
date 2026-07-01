module Lawyer
  class QuestionsController < ApplicationController
    def index
      @questions = Question.open.order(created_at: :desc)
    end

    def show
      @question = Question.includes(:user, answers: [:lawyer]).find(params[:id])
      @answer = @question.answers.build
    end
  end

  private
  def check_user_is_lawyer
    unless current_user&.lawyer?
      redirect_to root_path, alert: "You must be a lawyer to view this page."
    end
  end
end

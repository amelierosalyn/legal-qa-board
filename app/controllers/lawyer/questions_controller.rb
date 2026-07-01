module Lawyer
  class QuestionsController < ApplicationController
    before_action :check_user_is_lawyer
    before_action :get_question, only: [:show]
    before_action :check_question_available, only: [:show]

    def index
      @questions = Question.open.order(created_at: :desc)
    end

    def show
      @answer = @question.answers.build
    end

    private

    def get_question
      @question = Question.includes(:user, answers: [:lawyer]).find(params[:id])
    end

    def check_question_available
      if @question.closed?
        redirect_to lawyer_questions_path(as: "lawyer"), alert: "You cannot answer a closed question."
      elsif @question.answered?
        redirect_to lawyer_questions_path(as: "lawyer"), alert: "You cannot answer a question that has already been answered."
      end
    end

    def check_user_is_lawyer
      unless current_user&.lawyer?
        redirect_to root_path, alert: "You must be a lawyer to view this page."
      end
    end
  end
end

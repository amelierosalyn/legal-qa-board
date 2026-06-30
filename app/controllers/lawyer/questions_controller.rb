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
end

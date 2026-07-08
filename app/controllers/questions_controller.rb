class QuestionsController < ApplicationController
  before_action :get_question, only: [ :show, :destroy, :close ]

  def index
    @my_questions = current_user.questions.order(created_at: :desc)
  end

  def show
    @question = current_user.questions.includes(answers: [ :lawyer, :payment_request ]).find(params[:id])
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      respond_to do |format|
        format.html do
          redirect_to questions_path, notice: "Question submitted."
        end
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])

    if @question.destroy
      respond_to do |format|
        format.html { redirect_to questions_path, notice: "Question deleted." }

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(helpers.dom_id(@question, :my))
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to questions_path, alert: "Question could not be deleted." }
        format.turbo_stream { head :unprocessable_content }
      end
    end
  end

  def close
    @question.closed!

    respond_to do |format|
      format.html { redirect_to questions_path, notice: "Question closed." }

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            helpers.dom_id(@question, :my),
            partial: "questions/question",
            locals: { question: @question, dom_id_prefix: :my }
          )
        ]
      end
    end
  rescue ActiveRecord::RecordInvalid # didn't save
    respond_to do |format|
      format.html { redirect_to questions_path, alert: "Question could not be closed." }
      format.turbo_stream { head :unprocessable_content }
    end
  end

  private

  def get_question
    @question = current_user.questions.find_by(id: params[:id])

    if @question.nil?
      # May not exist for this user
      redirect_to questions_path, alert: "Question not found or access denied."
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, :category)
  end
end

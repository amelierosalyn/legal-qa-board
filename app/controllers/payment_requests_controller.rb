class PaymentRequestsController < ApplicationController
  def approve
    @payment_request = PaymentRequest
      .joins(answer: :question)
      .where(questions: { user: current_user })
      .find_by(id: params[:id])

    unless @payment_request
      redirect_to root_path, alert: "Answer not found or access denied."
      return
    end

    @payment_request.approve!
    @answer = @payment_request.answer

    respond_to do |format|
      format.html do
        redirect_to @answer.question, notice: "Payment has now been approved. Answer unlocked."
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          helpers.dom_id(@answer, :payment),
          partial: "lawyer/answers/payment_state",
          locals: { answer: @answer }
        )
      end
    end
  end
end

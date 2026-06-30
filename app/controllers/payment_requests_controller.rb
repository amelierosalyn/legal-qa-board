class PaymentRequestsController < ApplicationController
  def approve
    @payment_request = PaymentRequest.find(params[:id])
    @payment_request.approve!
    @answer = @payment_request&.answer

    if @answer.nil?
      redirect_to root_path, alert: "Answer not found."
      return
    end

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

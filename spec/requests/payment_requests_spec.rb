require "rails_helper"

RSpec.describe "PaymentRequests", type: :request do
  let!(:client) { User.find_by(email: "client@example.com") || FactoryBot.create(:user, name: "Client User", email: "client@example.com", role: :client) }
  let!(:lawyer) { User.find_by(email: "lawyer@example.com") ||  FactoryBot.create(:user, name: "Lawyer User", email: "lawyer@example.com", role: :lawyer) }
  let!(:question) do
    FactoryBot.create(
      :question,
      user: client,
      status: :open
    )
  end
  let!(:answer) do
    FactoryBot.create(
      :answer,
      question: question,
      lawyer: lawyer,
    )
  end

  describe "PATCH /payment_requests/:id/approve" do
    it "approves the payment and unlocks the answer for HTML requests" do
      patch approve_payment_request_path(answer.payment_request)

      expect(response).to redirect_to(question_path(question))
      expect(answer.payment_request.reload).to be_approved
      expect(answer.reload).to be_paid
      expect(question.reload).to be_answered
    end

    it "returns a turbo stream response when requested" do
      patch approve_payment_request_path(answer.payment_request), headers: {
        "ACCEPT" => "text/vnd.turbo-stream.html"
      }

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include('turbo-stream action="replace"')
      expect(response.body).to include(answer.response_text)
    end
  end
end

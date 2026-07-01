require "rails_helper"

RSpec.describe "Lawyer::Answers", type: :request do
  let!(:client) { User.find_by(email: "client@example.com") || FactoryBot.create(:user, name: "Client User", email: "client@example.com", role: :client) }
  let!(:lawyer) { User.find_by(email: "lawyer@example.com") ||  FactoryBot.create(:user, name: "Lawyer User", email: "lawyer@example.com", role: :lawyer) }

  let!(:question) do
    FactoryBot.create(
      :question,
      user: client,
    )
  end

  describe "POST /lawyer/questions/:question_id/answers" do
    it "creates an answer and pending payment request for HTML requests" do
      expect do
        post lawyer_question_answers_path(question, as: "lawyer"), params: {
          answer: {
            response_text: "Review the limitation of liability clause first.",
            proposed_fee_pounds: 45.00
          }
        }
      end.to change(Answer, :count).by(1)

      answer = question.answers.order(:created_at).last

      expect(answer.lawyer).to eq(lawyer)
      expect(answer.paid).to be(false)
      expect(answer.payment_request).to be_pending
      expect(response).to redirect_to(lawyer_questions_path(as: "lawyer"))
    end

    it "renders the question show template with errors for invalid input" do
      post lawyer_question_answers_path(question, as: "lawyer"), params: {
        answer: {
          response_text: "",
          proposed_fee_pence: 0
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("prevented this answer from being saved")
    end

    context 'when the user is not a lawyer' do
      it "renders the question show template with errors" do
        post lawyer_question_answers_path(question), params: {
          answer: {
            response_text: "Any answer",
            proposed_fee_pounds: 1.23
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("must be a lawyer")
      end
    end
  end
end

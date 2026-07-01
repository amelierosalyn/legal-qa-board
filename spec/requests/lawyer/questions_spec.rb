require "rails_helper"

RSpec.describe "Lawyer::Questions", type: :request do
  let!(:client) { User.find_by(email: "client@example.com") || FactoryBot.create(:user, name: "Client User", email: "client@example.com", role: :client) }
  let!(:lawyer) { User.find_by(email: "lawyer@example.com") ||  FactoryBot.create(:user, name: "Lawyer User", email: "lawyer@example.com", role: :lawyer) }
  let!(:open_question) do
    FactoryBot.create(
      :question,
      user: client,
      created_at: 2.days.ago
    )
  end
  let!(:answered_question) do
    FactoryBot.create(
      :question,
      user: client,
      status: :answered,
      created_at: 1.day.ago
    )
  end
  let!(:closed_question) do
    FactoryBot.create(
      :question,
      user: client,
      status: :closed,
      created_at: 1.day.ago
    )
  end

  describe "GET /lawyer/questions" do
    context 'when the user is not a lawyer' do
      it "redirects to root with an alert" do
        get lawyer_questions_path

        expect(response).to redirect_to(root_path)

        follow_redirect!

        expect(response.body).to include("must be a lawyer")
      end
    end

    context 'when the user is a lawyer' do
      it "lists only open questions" do
        get lawyer_questions_path(as: "lawyer")

        expect(response).to have_http_status(:success)
        expect(response.body).to include(open_question.title)
        expect(response.body).not_to include(answered_question.title)
        expect(response.body).not_to include(closed_question.title)
      end
    end
  end

  describe "GET /lawyer/questions/:id" do
    context "when the user is not a lawyer" do
      it "redirects to root with an alert" do
        get lawyer_question_path(open_question)

        expect(response).to redirect_to(root_path)

        follow_redirect!

        expect(response.body).to include("must be a lawyer")
      end
    end

    context "when the question is open" do
      it "shows the question with the answer form and existing responses" do
        FactoryBot.create(
          :answer,
          question: open_question,
          lawyer: lawyer,
          response_text: "Answer text",
          proposed_fee_pounds: 30.00
        )

        get lawyer_question_path(open_question, as: "lawyer")

        expect(response).to have_http_status(:success)
        expect(response.body).to include(open_question.title)
        expect(response.body).to include("Submit paid advice")
        expect(response.body).to include("Existing responses")
        expect(response.body).to include("£30.00")
        expect(response.body).to include("Awaiting payment")
      end
    end

    context 'when the question is closed' do
      it "redirects to the lawyer questions index with an alert" do
        get lawyer_question_path(closed_question, as: "lawyer")

        expect(response).to redirect_to(lawyer_questions_path(as: "lawyer"))
        follow_redirect!

        expect(response.body).to include("You cannot answer a closed question.")
      end
    end

    context 'when the question is answered' do
      it "redirects to the lawyer questions index with an alert" do
        get lawyer_question_path(answered_question, as: "lawyer")

        expect(response).to redirect_to(lawyer_questions_path(as: "lawyer"))
        follow_redirect!

        expect(response.body).to include("You cannot answer a question that has already been answered.")
      end
    end
  end
end

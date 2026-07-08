require "rails_helper"

RSpec.describe "Questions", type: :request do
  let!(:client) { User.find_by(email: "client@example.com") || FactoryBot.create(:user, name: "Client User", email: "client@example.com", role: :client) }
  let!(:lawyer) { User.find_by(email: "lawyer@example.com") ||  FactoryBot.create(:user, name: "Lawyer User", email: "lawyer@example.com", role: :lawyer) }
  let!(:question) do
    FactoryBot.create(
      :question,
      user: client,
      created_at: 2.days.ago
    )
  end

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(client)
  end

  describe "GET /" do
    it "shows the current user's recent questions" do
      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Legal Advice Q&amp;A Board")
      expect(response.body).to include(question.title)
    end
  end

  describe "GET /questions/:id" do
    it "shows a question and its locked answer state" do
      answer = FactoryBot.create(
        :answer,
        question: question,
        lawyer: lawyer
      )
      answer.create_payment_request!(status: :pending)

      get question_path(question)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(question.title)
      expect(response.body).to include(question.category.titleize)
      expect(response.body).to include(question.body)
      expect(response.body).to include("Approve payment to view this answer")
      expect(response.body).to include("Approve payment")
      expect(response.body).to include(answer.lawyer.name)
    end

    it "redirects with an alert when the question does not exist" do
      get question_path(id: 0)

      expect(response).to redirect_to(questions_path)
      follow_redirect!
      expect(response.body).to include("Question not found or access denied.")
    end

    it "redirects with an alert when the question belongs to another user" do
      other_question = FactoryBot.create(:question, user: lawyer)

      get question_path(other_question)

      expect(response).to redirect_to(questions_path)
      follow_redirect!
      expect(response.body).to include("Question not found or access denied.")
    end
  end

  describe "GET /questions/new" do
    it "renders the question form" do
      get new_question_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Submit a legal question")
    end
  end

  describe "POST /questions" do
    it "creates a question for the current user" do
      expect do
        post questions_path, params: {
          question: {
            title: "Question title",
            body: "Question text",
            category: "housing"
          }
        }
      end.to change(Question, :count).by(1)

      question = Question.order(:created_at).last

      expect(question.errors).to be_empty
      expect(question.user).to eq(client)
      expect(question.status).to eq("open")
      expect(response).to redirect_to(questions_path)
    end

    it "returns unprocessable entity when the question is invalid" do
      post questions_path, params: {
        question: {
          title: "",
          body: "",
          category: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("prevented this question from being saved")
    end
  end
end

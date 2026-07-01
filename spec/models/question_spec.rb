require "rails_helper"

RSpec.describe Question, type: :model do
  subject(:question) do
    FactoryBot.build(
      :question,
      user: FactoryBot.create(:user, role: :client)
    )
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_inclusion_of(:category).in_array(Question::CATEGORIES) }

  it "destroys associated answers" do
    question = FactoryBot.create(:question, user: FactoryBot.create(:user, role: :client))
    FactoryBot.create(:answer, question: question, lawyer: FactoryBot.create(:user, role: :lawyer))

    expect { question.destroy }.to change(Answer, :count).by(-1)
  end
end

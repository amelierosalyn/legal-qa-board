require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  context "when the user is a client" do
    subject(:client) { FactoryBot.build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to have_many(:questions).dependent(:destroy) }

    it "destroys associated questions" do
      user = FactoryBot.create(:user, role: :client)
      FactoryBot.create(:question, user: user)

      expect { user.destroy }.to change(Question, :count).by(-1)
    end
  end

  context "when the user is a lawyer" do
    subject(:lawyer) { FactoryBot.build(:lawyer) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to have_many(:answers).dependent(:destroy) }

    it "destroys answers written by the lawyer" do
      question = FactoryBot.create(:question, user: FactoryBot.create(:user))
      FactoryBot.create(:answer, question: question, lawyer: lawyer)

      expect { lawyer.destroy }.to change(Answer, :count).by(-1)
    end
  end
end

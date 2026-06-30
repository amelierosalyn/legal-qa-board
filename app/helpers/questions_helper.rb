module QuestionsHelper
  def current_user_question?(question)
    question.user == current_user
  end
end

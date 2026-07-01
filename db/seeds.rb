client = User.find_or_create_by!(email: "client@example.com") do |user|
  user.name = "Client User"
  user.role = :client
end

lawyer = User.find_or_create_by!(email: "lawyer@example.com") do |user|
  user.name = "Lawyer User"
  user.role = :lawyer
end

Question.find_or_create_by!(title: "Example question") do |question|
  question.user = client
  question.body = "I have a question. How should I proceed?"
  question.category = "housing"
  question.status = :open
end

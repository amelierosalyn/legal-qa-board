client = User.find_or_create_by!(email: "client@example.com") do |user|
  user.name = "Client User"
  user.role = :client
end

lawyer = User.find_or_create_by!(email: "lawyer@example.com") do |user|
  user.name = "Lawyer User"
  user.role = :lawyer
end

Question.find_or_create_by!(title: "Can my landlord increase my rent?") do |question|
  question.user = client
  question.body = "My landlord wants to increase my rent with very little notice. What are my options?"
  question.category = "Housing"
  question.status = :open
end

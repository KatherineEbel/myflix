Fabricator(:review) do
  rating { Faker::Number.between(from: 1, to: 5) }
  text { Faker::Lorem.paragraph(sentence_count: 3) }
  reviewer(fabricator: :user)
  video
end

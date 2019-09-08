Fabricator(:queue_item) do
  priority { Faker::Number.between(from: 1, to: 5) }
  user
  video
end

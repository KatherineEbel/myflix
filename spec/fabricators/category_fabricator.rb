# frozen_string_literal: true

Fabricator(:category) do
  name { Faker::Lorem.word }
end

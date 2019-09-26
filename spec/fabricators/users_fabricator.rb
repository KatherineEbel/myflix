# frozen_string_literal: true

Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
  reset_password_token nil
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
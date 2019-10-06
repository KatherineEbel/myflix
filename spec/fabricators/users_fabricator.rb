# frozen_string_literal: true

Fabricator(:user) do
  customer_id 'cus_123test'
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
  reset_password_token nil
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end

Fabricator(:registration_candidate, from: :user) do
  stripe_token 'my_token'
  referral_id nil
end
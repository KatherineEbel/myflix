# frozen_string_literal: true

Fabricator(:video) do
  title { Faker::Lorem.word }
  category
  description { Faker::Lorem.words(number: 20).join(' ') }
  video_url 'https://www.google.com'
  small_cover do
    Rails.root.join('spec/fixtures/monk.jpg').open
  end
  large_cover do
    Rails.root.join('spec/fixtures/monk_large.jpg').open
  end
end

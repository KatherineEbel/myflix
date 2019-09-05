# frozen_string_literal: true

Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.words(number: 20).join(' ') }
  small_cover_url { Faker::LoremFlickr.image(size: '166x236') }
  large_cover_url { Faker::LoremFlickr.image(size: '665x375') }
  category
end

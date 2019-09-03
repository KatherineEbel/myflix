# frozen_string_literal: true

require 'rails_helper'

describe Video, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('Category') }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe Category, type: :model do
  describe 'associations' do
    it { should have_many :videos }
  end
end

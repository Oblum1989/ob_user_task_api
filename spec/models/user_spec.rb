require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:role) }
  end

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(admin: 0, user: 1, guest: 2) }
  end
end

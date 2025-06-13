require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1, expired: 2, archived: 3) }
  end
end


require 'rails_helper'

RSpec.describe Account do
  subject(:account) { build(:account) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:balance) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'account create' do
    before { account.save }

    it { is_expected.to be_persisted }
  end
end

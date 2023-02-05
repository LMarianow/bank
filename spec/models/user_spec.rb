
require 'rails_helper'

RSpec.describe Account do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_presence_of(:cpf) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:account).optional }
  end

  describe 'user create' do
    before { user.save }

    it { is_expected.to be_persisted }
  end

  describe 'user create with account' do
    it 'must to create an account too' do
      expect{ user.save }.to change(Account, :count).by(1)
        .and change(User, :count).by(1)
    end
  end
end

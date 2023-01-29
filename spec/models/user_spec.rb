
require 'rails_helper'

RSpec.describe Account do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_presence_of(:cpf) }
    it { is_expected.to validate_presence_of(:name) }
  end

  # describe 'associations' do
  #   it { is_expected.to has_one(:account).optional }
  # end

  describe 'user create' do
    before { 
        # byebug
        user.save }

    it { is_expected.to be_persisted }
  end
end

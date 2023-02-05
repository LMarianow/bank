
require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build(:event) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end

  describe 'event create' do
    before { event.save }

    it { is_expected.to be_persisted }
  end

  describe 'instance methods' do
    let!(:account) { create(:account) }

    before { Event.add_event('deposit', 'deposit in the value 50', account) }

    it 'must created an event'do
        expect(Event.count).to eq(1)
    end
  end
end

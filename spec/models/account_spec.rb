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

  describe 'instance methods' do
    let!(:account2) { create(:account) }

    context '#deposit' do
      before { account2.deposit(50) }

      it 'must be deposited the value' do
        expect(account2.reload.balance).to eq(50)
      end
    end

    context '#withdraw' do
      let!(:account2) { create(:account, balance: 200) }

      context 'account have balance suficient' do
        before { account2.withdraw(50) }

        it 'must be withdraw the value' do
          expect(account2.reload.balance).to eq(150)
        end
      end

      context 'account dont have balance suficient' do
        it 'dont must be withdraw the value' do
          expect{account2.withdraw(500)}.to raise_error(ArgumentError)
        end
      end
    end
  end

  context '#transference' do
      let!(:account2) { create(:account, balance: 200) }
      let!(:account3) { create(:account, balance: 500) }

      context 'account have balance suficient' do
            before do
                Timecop.freeze(DateTime.new(2023, 7, 15, 0)) do
                    account2.transference(100, account3.user.email)
                end
            end
            after do
                Timecop.return
            end
            it 'must be transference the value', :aggregate_failures do
                expect(account2.reload.balance).to eq(93)
                expect(account3.balance).to eq(500)
            end
        end
    end

    context 'account dont have balance suficient' do
        it 'dont must be transference the value' do
          expect{account2.transference(5000, account3.user.email)}.to raise_error(ArgumentError)
        end
    end
end
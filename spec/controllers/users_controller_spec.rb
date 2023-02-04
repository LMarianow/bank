require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Warden::Test::Helpers
  include Devise::Test::ControllerHelpers

  let(:valid_attributes) {{
    name: 'Lucas',
    password: '1234',
    email: 'lucas@gmail.com',
    cpf: '754245721'
  }}

  let(:invalid_attributes) {{
    Name: 'Lucas',
    email: 'lucas@gmail.com',
  }}

  describe "POST /create" do
    context "with valid parameters" do
      let(:do_request) do
        post :create, params: { user: valid_attributes  }
      end

      it "creates a new User" do
        expect {
          do_request
        }.to change(User, :count).by(1)
        .and change(Account, :count).by(1)

        expect(response).to redirect_to(root_path)
      end

      it "redirects to the created user" do
        do_request
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      let(:do_request) do
        post :create, params:  { user: invalid_attributes  }
      end
      it "does not create a new User" do
        expect{ do_request }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "GET /index" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    it "renders a successful response" do
      get :index, params: { }, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let(:do_request) do
      get :show, params: { id: user.id }, as: :json
    end

    context 'no login' do
        it 'return error if not logged in' do
          expect(do_request).to redirect_to(root_path)
        end
    end

    it "renders a successful response" do
      login(user)
      do_request
      expect(response).to be_successful
    end
  end

  describe "PUT /edit" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let(:params) { { name: 'Valdemar' } }
    let(:do_request) do
      put :update, params: { id: user.id, user: params  }, as: :json
    end

    context 'no login' do
        it 'return error if not logged in' do
          expect(do_request).to redirect_to(root_path)
        end
    end

    it "renders a successful response" do
      login(user)
      do_request
      expect(response).to be_successful
      expect(user.reload.name).to eq('Valdemar')
    end
  end

  describe "DELETE /destroy" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let(:do_request) do
      delete :destroy, params: { id: user.id  }, as: :json
    end

    it "must not allowed to destroy account" do
      login(user)

      expect {
        do_request
      }.to raise_error(StandardError)
       .and change(User, :count).by(0)
       .and change(Account, :count).by(0)
    end
  end

  describe "post /deposit" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        id: user.id,
        quantity: 50.0
      }
    end

    let(:do_request) do
        post :deposit, params: params, as: :json
    end

    context 'no login' do
        it 'return error if not logged in' do
          expect(do_request).to redirect_to(root_path)
        end
    end

    it "renders a successful response" do
      login(user)
      do_request

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "get /withdraw" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        id: user.id,
        quantity: 50.0
      }
    end

    let(:do_request) do
      get :withdraw, params: params, as: :json
    end

    context 'no login' do
      it 'return error if not logged in' do
        expect(do_request).to redirect_to(root_path)
      end
    end

    context 'balance suficient' do
      before do
        login(user)
        account.update(balance: 200)
        account.reload

        do_request
      end

      it "renders a successful response", :aggregate_failures do
        expect{ account.reload }
          .to change(account, :balance).from(200).to(150)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'balance insuficient' do
      before { login(user) }

      it "renders error response", :aggregate_failures do
        expect{ do_request }
          .to raise_error(ArgumentError)
      end
    end
  end


  describe "post /transference" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let!(:account2) { create(:account) }
    let!(:user2) { account2.user }

    let(:params) do
      {
        id: user.id,
        quantity: 50.0,
        email: user2.email
      }
    end

    let(:do_request) do
      post :transference, params: params, as: :json
    end

    context 'no login' do
      it 'return error if not logged in' do
        expect(do_request).to redirect_to(root_path)
      end
    end

    context 'balance suficient' do
      before do
        login(user)
        account.update(balance: 200)
        Timecop.freeze(DateTime.new(2023, 7, 15, 0)) do
        do_request
        end
      end

      after do
        Timecop.return
      end

      it "renders a successful response", :aggregate_failures do
        expect{ account.reload }
          .to change(account, :balance).from(200).to(143)
        expect{ account2.reload }
          .to change(account2, :balance).from(0).to(50)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'balance insuficient' do
      before { login(user) }

      it "renders error response", :aggregate_failures do
        expect{ do_request }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "get /balance" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        id: user.id,
        quantity: 50.0
      }
    end

    let(:do_request) do
        get :balance, params: params, as: :json
    end

    context 'no login' do
        it 'return error if not logged in' do
          expect(do_request).to redirect_to(root_path)
        end
    end

    context 'authenticated' do
        before do
            login(user)
            account.update(balance: 200)
            do_request
        end

        it "renders a successful response", :aggregate_failures do
          expect(response).to have_http_status(:ok)
        end
    end
  end

  describe "get /extract" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let!(:events) { FactoryBot.create_list(:event, 5, account: account) }

    let(:params) do
      {
        id: user.id,
        date_from: DateTime.new(2023,1,28),
        date_to: DateTime.new(2023,2,2)
      }
    end

    let(:do_request) do
        get :extract, params: params, as: :json
    end

    context 'no login' do
        it 'return error if not logged in' do
          expect(do_request).to redirect_to(root_path)
        end
    end

    it "renders a successful response", :aggregate_failures do
      login(user)
      events.last.update(created_at: DateTime.new(2023,1,25))
      do_request

      expect(response).to have_http_status(:no_content)
    end
  end
end

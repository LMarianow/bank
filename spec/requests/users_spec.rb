require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/users", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {{
    name: 'Lucas',
    password_digest: '1234',
    email: 'lucas@gmail.com',
    cpf: '754245721'
  }}

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      User.create! valid_attributes
      get users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "GET /signin" do
    it "renders a successful response" do
      user = User.create! valid_attributes
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        .and change(Account, :count).by(1)
      end

      it "redirects to the created user" do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete user_url(user)
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end


  describe "post /deposit" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        quantity: 50.0
      }
    end

    it "renders a successful response" do
      post deposit_user_path(user), params: params, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end

  describe "get /withdraw" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        quantity: 50.0
      }
    end

    context 'balance suficient' do
      before do
        account.update(balance: 200)
        account.reload

        get withdraw_user_path(user), params: params, as: :json
      end

      it "renders a successful response", :aggregate_failures do
        expect{ account.reload }
          .to change(account, :balance).from(200).to(150)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'balance insuficient' do
      it "renders error response", :aggregate_failures do
        expect{ get withdraw_user_path(user), params: params, as: :json }
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
        quantity: 50.0,
        email: user2.email
      }
    end

    context 'balance suficient' do
      before do
        account.update(balance: 200)
        post transference_user_path(user), params: params, as: :json
      end

      it "renders a successful response", :aggregate_failures do
        expect{ account.reload }
          .to change(account, :balance).from(200).to(150)
        expect{ account2.reload }
          .to change(account2, :balance).from(0).to(50)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'balance insuficient' do
      it "renders error response", :aggregate_failures do
        expect{ post transference_user_path(user), params: params, as: :json }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe "get /balance" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }

    let(:params) do
      {
        quantity: 50.0
      }
    end

    before do
      account.update(balance: 200)

      get balance_user_path(user), params: params, as: :json
    end

    it "renders a successful response", :aggregate_failures do
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "get /extract" do
    let!(:account) { create(:account) }
    let!(:user) { account.user }
    let!(:events) { FactoryBot.create_list(:event, 5, account: account) }

    let(:params) do
      {
        date_from: DateTime.new(2023,1,28),
        date_to: DateTime.new(2023,2,2)
      }
    end

    before do
      events.last.update(created_at: DateTime.new(2023,1,25))

      get extract_user_path(user), params: params, as: :json
    end

    it "renders a successful response", :aggregate_failures do
      expect(response).to have_http_status(:no_content)
    end
  end
end

require 'rails_helper'
require 'bcrypt'

RSpec.describe "Sessions", type: :request do
  include BCrypt

  describe "post /create" do
    let!(:user) { create(:user, password_digest: BCrypt::Password.create('123456')) }

    context 'login success' do

      let(:params) do
        {
          session: {
            email: user.email,
            password: '123456'
          }
        }
      end

      before { post sign_in_path, params: params }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'login failure' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: '123'
          }
        }
      end

      before { post sign_in_path, params: params }

      it "returns unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'login failure' do
      let(:params) do
        {
          session: {
            email: user.email,
            password: '123'
          }
        }
      end

      before { post sign_in_path, params: params }

      it "returns unauthorized response" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end

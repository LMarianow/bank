require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      name: "Name",
      cpf: "Cpf",
      password_digest: "Password Digest",
      email: "teste@gmail.com"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Cpf/)
    expect(rendered).to match(/Password Digest/)
    expect(rendered).to match(/Email/)
  end
end

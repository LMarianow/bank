require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      name: "MyString",
      cpf: "MyString",
      password_digest: "MyString",
      email: "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[name]"

      assert_select "input[name=?]", "user[cpf]"

      assert_select "input[name=?]", "user[password_digest]"

      assert_select "input[name=?]", "user[email]"
    end
  end
end

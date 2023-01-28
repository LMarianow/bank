require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        balance: "9.99"
      ),
      Account.create!(
        balance: "9.99"
      )
    ])
  end

  it "renders a list of accounts" do
    render
    assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end

require 'rails_helper'

RSpec.describe "fields/edit", type: :view do
  let(:field) {
    Field.create!(
      name: "MyString",
      shape: "MyString",
      area: "MyString"
    )
  }

  before(:each) do
    assign(:field, field)
  end

  it "renders the edit field form" do
    render

    assert_select "form[action=?][method=?]", field_path(field), "post" do

      assert_select "input[name=?]", "field[name]"

      assert_select "input[name=?]", "field[shape]"

      assert_select "input[name=?]", "field[area]"
    end
  end
end

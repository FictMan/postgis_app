require 'rails_helper'

RSpec.describe "fields/index", type: :view do
  before(:each) do
    assign(:fields, [
      Field.create!(
        name: "Name",
        shape: "Shape",
        area: "Area"
      ),
      Field.create!(
        name: "Name",
        shape: "Shape",
        area: "Area"
      )
    ])
  end

  it "renders a list of fields" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Shape".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Area".to_s), count: 2
  end
end

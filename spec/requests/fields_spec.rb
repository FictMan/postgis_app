require 'rails_helper'

RSpec.describe "/fields", type: :request do
  let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }
  let(:fake_multipolygon) do
    polygon = factory.polygon(
      factory.linear_ring([
        factory.point(0, 0),
        factory.point(0, 1),
        factory.point(1, 1),
        factory.point(1, 0),
        factory.point(0, 0)
      ])
    )
    factory.multi_polygon([polygon])
  end

  let(:valid_attributes) {
    { name: 'asjkdhaksd', shape: fake_multipolygon }
  }

  let(:invalid_attributes) {
    { name: '', field: '' }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Field.create! valid_attributes
      get fields_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      field = Field.create! valid_attributes
      get field_url(field)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_field_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      field = Field.create! valid_attributes
      get edit_field_url(field)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Field" do
        expect {
          post fields_url, params: { field: valid_attributes }
        }.to change(Field, :count).by(1)
      end

      it "redirects to the created field" do
        post fields_url, params: { field: valid_attributes }
        expect(response).to redirect_to(field_url(Field.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Field" do
        expect {
          post fields_url, params: { field: invalid_attributes }
        }.to change(Field, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post fields_url, params: { field: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:fake_multipolygon) do
        polygon = factory.polygon(
          factory.linear_ring([
            factory.point(2, 0),
            factory.point(0, 2),
            factory.point(2, 2),
            factory.point(2, 0),
            factory.point(0, 0)
          ])
        )
        factory.multi_polygon([polygon])
      end
      let(:new_attributes) {
        { name: 'Some new name', shape: fake_multipolygon }
      }

      it "updates the requested field" do
        field = Field.create! valid_attributes
        patch field_url(field), params: { field: new_attributes }
        field.reload
        expect(field.name).to eq(new_attributes[:name])
        expect(field.shape).to eq(fake_multipolygon)
      end

      it "redirects to the field" do
        field = Field.create! valid_attributes
        patch field_url(field), params: { field: new_attributes }
        field.reload
        expect(response).to redirect_to(field_url(field))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        field = Field.create! valid_attributes
        patch field_url(field), params: { field: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested field" do
      field = Field.create! valid_attributes
      expect {
        delete field_url(field)
      }.to change(Field, :count).by(-1)
    end

    it "redirects to the fields list" do
      field = Field.create! valid_attributes
      delete field_url(field)
      expect(response).to redirect_to(fields_url)
    end
  end
end

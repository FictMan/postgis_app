class Field < ApplicationRecord
  after_save :calculate_area

  def shape_as_geojson
    RGeo::GeoJSON.encode(shape)
  end

  private

  def calculate_area
    # self.area = shape.geometry.area
  end
end

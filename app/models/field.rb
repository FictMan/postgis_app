class Field < ApplicationRecord
  before_save :calculate_area

  validates_presence_of :name, :shape

  def shape_as_geojson
    RGeo::GeoJSON.encode(shape)
  end

  private

  def calculate_area
    spherical_factory = RGeo::Geographic.spherical_factory(srid: 4326)
    utm_factory = RGeo::Geographic.projected_factory(
      projection_proj4: '+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs',
      projection_srid: 32636,
      geographic_srid: 4326
    )
    projected_multipolygon = RGeo::Feature.cast(shape, factory: utm_factory)
    self.area = projected_multipolygon.area
  end
end

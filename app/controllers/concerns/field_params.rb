module FieldParams
  extend ActiveSupport::Concern

  def field_params
    params.require(:field).permit(:name)
  end

  def shape_attr
    shape_geojson = params[:field][:shape]
    if is_wkt?(shape_geojson)
      factory = RGeo::Geographic.spherical_factory(srid: 4326)
      factory.parse_wkt(shape_geojson)
    elsif is_geojson?(shape_geojson)
      RGeo::GeoJSON.decode(shape_geojson, json_parser: :json)
    end
  end

  private

  def is_wkt?(input)
    input.is_a?(String) && input.strip.match?(/\A(POINT|LINESTRING|POLYGON|MULTIPOLYGON|GEOMETRYCOLLECTION)/i)
  end

  def is_geojson?(input)
    input.is_a?(String) && input.strip.start_with?("{") && input.include?('"type"')
  end
end

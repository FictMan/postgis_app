# frozen_string_literal: true

FactoryBot.define do
  factory :client, class: 'Field' do
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    polygon = factory.polygon(
        factory.linear_ring([
          factory.point(0, 0),
          factory.point(0, 1),
          factory.point(1, 1),
          factory.point(1, 0),
          factory.point(0, 0)
        ])
      )

    name { Faker::Name.name }
    shape { factory.multi_polygon([polygon]) }
  end
end

document.addEventListener("DOMContentLoaded", function() {
  // Initialize the map
  var map = L.map('map').setView([51.505, -0.09], 13); // Set initial coordinates and zoom level

  // Add a tile layer (basemap) from OpenStreetMap
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
  }).addTo(map);

  // Define the GeoJSON data (this could come from your Rails app)
  var geojsonFeature = {
    "type": "Feature",
    "geometry": {
      "type": "Polygon",
      "coordinates": [
        [
          [-0.09, 51.505],
          [-0.08, 51.505],
          [-0.08, 51.51],
          [-0.09, 51.51],
          [-0.09, 51.505]
        ]
      ]
    }
  };

  // Add the GeoJSON layer to the map
  L.geoJSON(geojsonFeature).addTo(map);
});

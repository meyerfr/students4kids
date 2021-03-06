import 'mapbox-gl/dist/mapbox-gl.css';

import mapboxgl from 'mapbox-gl/dist/mapbox-gl.js';

// const initMapbox = () => {
  const mapElement = document.getElementById('map');
  const api_key = process.env.MAPBOX_API_KEY;
  console.log(api_key);
  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = process.env.MAPBOX_API_KEY;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });
  }
// };

// export { initMapbox };

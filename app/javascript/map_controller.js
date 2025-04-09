import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {
    static values = {
        mapboxApiKey: String,
        volunteers: Array
    }

    connect() {
        console.log('Map controller connected');
        console.log('Volunteers data:', this.volunteersValue);

        if (!this.mapboxApiKeyValue || !this.volunteersValue || this.volunteersValue.length === 0) {
            console.error('Missing required data for map');
            return;
        }

        try {
            this.initializeMap();
            this.addMarkers();
            this.addMapControls();
        } catch (error) {
            console.error('Map initialization error:', error);
        }
    }

    initializeMap() {
        this.map = new mapboxgl.Map({
            container: this.element,
            style: 'mapbox://styles/mapbox/streets-v11',
            center: this.calculateCenter(),
            zoom: 10
        });

        this.map.on('load', () => {
            console.log('Mapbox map loaded successfully');
        });
    }

    calculateCenter() {
        if (this.volunteersValue.length > 0) {
            const firstVolunteer = this.volunteersValue[0];
            return this.geocodeLocation(firstVolunteer.city) || [30.5, 50.5];
        }
        return [30.5, 50.5];
    }

    geocodeLocation(city) {

        const locations = {
            'Киев': [30.5234, 50.4501],
            'Львов': [24.0316, 49.8429],
            'Одесса': [30.7233, 46.4825]

        };
        return locations[city];
    }

    addMarkers() {
        this.volunteersValue.forEach(volunteer => {
            const el = this.createMarkerElement(volunteer);
            const popup = this.createPopup(volunteer);

            new mapboxgl.Marker(el)
                .setLngLat(this.getMarkerCoordinates(volunteer))
                .setPopup(popup)
                .addTo(this.map);
        });
    }

    createMarkerElement(volunteer) {
        const el = document.createElement('div');
        el.className = 'volunteer-marker';

        if (volunteer.avatar_url) {
            el.innerHTML = `<img src="${volunteer.avatar_url}" class="w-8 h-8 rounded-full border-2 border-white">`;
        } else {
            el.innerHTML = `<div class="w-8 h-8 rounded-full bg-blue-500 text-white flex items-center justify-center">${volunteer.name[0]}</div>`;
        }

        return el;
    }

    createPopup(volunteer) {
        return new mapboxgl.Popup({ offset: 25 })
            .setHTML(`
        <div class="p-2">
          <h3 class="font-bold">${volunteer.name}</h3>
          <p class="text-sm text-gray-600">${volunteer.city}, ${volunteer.country}</p>
          ${volunteer.avatar_url ? `<img src="${volunteer.avatar_url}" class="w-16 h-16 rounded-full mt-2 mx-auto">` : ''}
        </div>
      `);
    }

    getMarkerCoordinates(volunteer) {

        const center = this.calculateCenter();
        return [
            center[0] + (Math.random() * 0.1 - 0.05),
            center[1] + (Math.random() * 0.1 - 0.05)
        ];
    }

    addMapControls() {
        this.map.addControl(new mapboxgl.NavigationControl());
        this.map.addControl(new mapboxgl.GeolocateControl({
            positionOptions: {
                enableHighAccuracy: true
            },
            trackUserLocation: true
        }));
    }
}
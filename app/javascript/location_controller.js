import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["countrySelect", "citySelect"]

    static values = {
        apiUrl: { type: String, default: "https://countriesnow.space/api/v0.1/countries" }
    }

    connect() {
        this.currentCountry = this.countrySelectTarget.dataset.selected || ""
        this.currentCity = this.citySelectTarget.dataset.selected || ""
        this.loadCountries()
    }

    async loadCountries() {
        try {
            // Временное отображение текущей страны
            if (this.currentCountry) {
                this.countrySelectTarget.innerHTML = `
                    <option value="${this.currentCountry}" selected>${this.currentCountry}</option>
                    <option value="">Select country</option>
                `
            } else {
                this.countrySelectTarget.innerHTML = '<option value="">Loading countries...</option>'
            }

            const response = await fetch(this.apiUrlValue)
            if (!response.ok) throw new Error("Failed to fetch countries")

            const { data: countries } = await response.json()
            this.countriesData = countries

            let options = this.currentCountry
                ? `<option value="${this.currentCountry}" selected>${this.currentCountry}</option>`
                : '<option value="">Select country</option>'

            countries
                .sort((a, b) => a.country.localeCompare(b.country))
                .forEach(({ country }) => {
                    if (country !== this.currentCountry) {
                        options += `<option value="${country}">${country}</option>`
                    }
                })

            this.countrySelectTarget.innerHTML = options
            this.setupCityLoading()

            if (this.currentCountry) {
                await this.loadCitiesForCountry(this.currentCountry, true)
            }
        } catch (error) {
            console.error("Error loading countries:", error)
            this.countrySelectTarget.innerHTML = `
                <option value="">Error loading countries</option>
                ${this.currentCountry ? `<option value="${this.currentCountry}" selected>${this.currentCountry}</option>` : ''}
            `
        }
    }

    setupCityLoading() {
        this.countrySelectTarget.addEventListener("change", async (e) => {
            await this.loadCitiesForCountry(e.target.value, false)
        })
    }

    async loadCitiesForCountry(countryName, isInitialLoad = false) {
        if (!countryName) {
            this.citySelectTarget.innerHTML = '<option value="">Select city</option>'
            return
        }

        try {
            const countryData = this.countriesData.find(c => c.country === countryName)
            if (!countryData?.cities) {
                this.citySelectTarget.innerHTML = '<option value="">No cities found</option>'
                return
            }
            const allCities = [...countryData.cities]
            const sortedCities = allCities.sort((a, b) => a.localeCompare(b))

            const shouldPreserveCurrentCity = isInitialLoad &&
                countryName === this.currentCountry &&
                this.currentCity &&
                allCities.includes(this.currentCity)

            let options = shouldPreserveCurrentCity
                ? `<option value="${this.currentCity}" selected>${this.currentCity}</option>`
                : '<option value="">Select city</option>'

            sortedCities.forEach(city => {
                if (!shouldPreserveCurrentCity || city !== this.currentCity) {
                    options += `<option value="${city}">${city}</option>`
                }
            })

            this.citySelectTarget.innerHTML = options

        } catch (error) {
            console.error("Error loading cities:", error)
            this.citySelectTarget.innerHTML = `
                <option value="">Error loading cities</option>
                ${this.currentCity && isInitialLoad ? `<option value="${this.currentCity}" selected>${this.currentCity}</option>` : ''}
            `
        }
    }
}
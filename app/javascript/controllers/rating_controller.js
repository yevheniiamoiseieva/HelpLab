// app/javascript/controllers/rating_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["star", "input"]

    connect() {
        this.updateStars(parseInt(this.inputTarget.value || 0))
    }

    select(event) {
        const rating = parseInt(event.currentTarget.dataset.value)
        this.inputTarget.value = rating
        this.updateStars(rating)
    }

    updateStars(rating) {
        this.starTargets.forEach((star, index) => {
            star.textContent = index < rating ? "★" : "☆"
        })
    }
}

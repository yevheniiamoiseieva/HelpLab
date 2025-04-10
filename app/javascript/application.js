import { Application } from "@hotwired/stimulus"
import HelloController from "./controllers/hello_controller"
import LocationController from "./controllers/location_controller"



const application = Application.start()
application.register("hello", HelloController)
application.register("location", LocationController)

application.debug = false
window.Stimulus = application

export { application }
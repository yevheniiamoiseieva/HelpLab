import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import RatingController from "./rating_controller"
application.register("rating", RatingController)

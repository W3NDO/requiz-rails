import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  connect () {
    super.connect()
  }

  highlight(e){
    e.target.closest("button").classList.remove("is-primary")
    e.target.classList.add("selected");
  }
}

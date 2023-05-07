import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    super.connect()
  }

  show_notification(){
    console.log("SHOW NOTIFICATION");
  }

  test(){
    console.log("SHOW NOTIFICATION");
  }
}

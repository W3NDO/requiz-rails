import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    super.connect();
  }

  startRefreshing(){  
    this.stopRefreshing
    this.refreshTimer = setInterval( () => {
      if(this.timeValue > 0 && this.pausedValue == false){
        this.setClock(this.timeValue - 1)
      } else {
        this.stopRefreshing
        this.pausedValue = true
        this.togglePlayPauseButton
      }
    }, 1000);
  }

  stopRefreshing(){
    if( this.refreshTimer ){
      clearInterval(this.refreshTimer);
    }
  }

  static values = {
    time: Number,
    paused: Boolean
  };

  static targets = [
    "timersList", 
    "clock", 
    "addTime", 
    "subtractTime", 
    "startTimer", 
    "stopTimer",
    "isPaused"
  ];

  toggleTimes(){
    console.log(this.pausedValue);
    var is_visible = this.timersListTarget.classList.contains("hidden");
    if(is_visible){
      this.timersListTarget.classList.remove("hidden");
    }else{
      this.timersListTarget.classList.add("hidden");
    }
  }

  addTime(e){
    var caller = e.target.closest("button");
    var currentTotal = this.timeValue;
    if(caller.hasAttribute){
      var timeToAdd = Number(caller.value)*60
    } else {
      console.error("There was no value");
      var timeToAdd = 0
    }
    currentTotal += timeToAdd;
    this.setClock(currentTotal);
  }

  subtractTime(e){
    var caller = e.target.closest("button");
    var currentTotal = this.timeValue;
    if(caller.hasAttribute){
      var timeToSubtract = Number(caller.value)*60
    } else {
      console.error("There was no value");
      var timeToSubtract = 0
    }
    if(currentTotal - timeToSubtract < 0){
      currentTotal = 0;
    } else{
      currentTotal -= timeToSubtract;
    }
    this.setClock(currentTotal);
  }
  
  divmod(val, div){
    return([Math.floor(val/div), val%div]);
  }

  setClock(time){
    this.timeValue = time;
    this.clockTarget.innerHTML = this.formatTime(time);
  }

  formatTime(time){
    var m, s, h;
    [m,s] = this.divmod(time, 60);
    [h,m] = this.divmod(m, 60);
    return `${h < 10 ? `0${h}` : h }:${m < 10 ? `0${m}` : m }:${s < 10 ? `0${s}` : s }`
  }

  startTimer(){
    this.pauseTimerValue = !(this.pauseTimerValue);
    console.log("IS PAUSED? ", this.pauseTimerValue);
    this.stimulate('Application#show_notification', this.formatTime(this.timeValue) );
    this.startRefreshing()
  }
}

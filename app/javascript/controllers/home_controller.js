import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  connect () {
    super.connect()
  }

  static targets = ["dropdown", "toggleBtn", "selectionBar"]

  toggleDropdown(){
    if (Array.from(this.dropdownTarget.classList).includes("hidden")){
      this.dropdownTarget.classList.remove("hidden")
      this.toggleBtnTarget.innerHTML = `<span class="text-3xl"> <i class="fa-solid fa-xmark" aria-hidden="true"></i> </span>`
    } else {
      this.dropdownTarget.classList.add("hidden")
      this.toggleBtnTarget.innerHTML = `<span class="text-3xl"> <i class="fa-solid fa-bars" aria-hidden="true"></i> </span> `
    }
  }

  optionSelected(){
    this.toggleDropdown();
  }

  toggleSelectionBar(){
    var arr = Array.from(this.selectionBarTarget.classList)
    if(!(arr.includes("not-mobile"))){ //because tailwind is mobile first, this action will only happen on screens smaller than the lg breakpoint
      if(arr.includes("hidden")){
        this.selectionBarTarget.classList.remove("hidden")
      }else{
        this.selectionBarTarget.classList.add("hidden")
      }
    }
  }
}

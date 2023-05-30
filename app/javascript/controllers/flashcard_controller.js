import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    super.connect()
  }
  static targets = ["index"]

  getFlashcardIndex(){
    return Number(this.indexTarget.innerHTML)
  }

  nextFlashcard(){
    this.showFlashcard( this.getFlashcardIndex += 1 );
    let flashcards = Array.from(document.getElementsByClassName("flashcards"))
    if( this.indexTarget.innerHTML >= flashcards.length -1 ){
      this.indexTarget.innerHTML = 0
    } else {
      this.indexTarget.innerHTML = Number(this.indexTarget.innerHTML) + 1
    }
  }
  
  previousFlashcard(){
    this.showFlashcard( this.getFlashcardIndex -= 1 );
    let flashcards = Array.from(document.getElementsByClassName("flashcards"))
    if( this.indexTarget.innerHTML <= 0 ){
      this.indexTarget.innerHTML = flashcards.length -1
    } else {
      this.indexTarget.innerHTML = Number(this.indexTarget.innerHTML) - 1
    }
  }

  showFlashcard(n){
    let flashcardIndex;
    let flashcards = Array.from(document.getElementsByClassName("flashcards"))
    if(n >= flashcards.length - 1){ 
      flashcardIndex = 0 
    } else if( n < 1){ 
      flashcardIndex = flashcards.length - 1 
    } else {
      flashcardIndex = Number(this.indexTarget.innerHTML) ;
    }
    flashcards.map( card => {
      if(card == flashcards[flashcardIndex]){
        card.classList.remove("hidden");
      } else {
        card.classList.add("hidden");
      }
    })
  }
}

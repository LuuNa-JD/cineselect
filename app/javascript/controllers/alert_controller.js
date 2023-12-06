import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  connect() {
    this.fadeOutAfterTimeout();
  }

  fadeOutAfterTimeout() {
    setTimeout(() => {
      this.closeAlert();
    }, 3000);
  }

  closeAlert() {
    this.element.classList.add("fade-out");
    setTimeout(() => {
      this.element.remove(); // Remove the element after the fade-out animation
    }, 500);
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  static targets = ["loader", "start"];
  connect() {

    setTimeout(() => {
      this.redirect();
    }, 3000);
  }

  redirect() {

    this.loaderTarget.classList.add("d-none")
    this.startTarget.classList.remove("d-none")
  }
}

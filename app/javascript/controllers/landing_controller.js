import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="landing"
export default class extends Controller {
  connect() {

    setTimeout(() => {
      this.redirect();
    }, 6000);
  }

  redirect() {

    window.location.href = "/seances/new";
  }
}

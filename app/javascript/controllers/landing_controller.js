import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {

      setTimeout(() => {
        this.redirect();
      }, 6000);
    }

    redirect() {
      window.location.href = "/seances/new";
    };
}

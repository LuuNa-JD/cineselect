import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="platform"
export default class extends Controller {
  static targets = ["logo", "hiddenField"];

  toggleSelection(event) {
    const logo = event.currentTarget;
    logo.classList.toggle("selected");

    const targetId = logo.dataset.target;
    const hiddenField = this.hiddenFieldTargets.find((field) => field.id === targetId);
    if (hiddenField) {
      hiddenField.disabled = !hiddenField.disabled;
    }
  }
}

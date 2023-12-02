import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["platform", "hiddenField"];

  toggleSelection(event) {
    const logo = event.currentTarget;
    logo.classList.toggle('selected');

    const hiddenField = this.hiddenFieldTargets.find(field => field.dataset.platform === logo.dataset.platform);
    if (hiddenField) {
      hiddenField.disabled = !hiddenField.disabled;
    }
  }
}
// hello from platform_controller.js

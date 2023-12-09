import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["platform", "hiddenField"];

  toggleSelection(event) {
    const logo = event.currentTarget;
    if (logo.classList.contains("selected")){

      logo.classList.remove('selected');
      logo.classList.add("unselected")
    }else{
      logo.classList.remove("unselected")
      logo.classList.add("selected")
    }

    const hiddenField = this.hiddenFieldTargets.find(field => field.dataset.platform === logo.dataset.platform);
    if (hiddenField) {
      hiddenField.disabled = !hiddenField.disabled;
    }
  }
}

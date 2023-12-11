import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: Number, title: String, imageUrl: String, mediaType: String }

  async toggle(event) {
    event.preventDefault();

    try {
      const response = await fetch('/favorites/toggle', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': this.getMetaValue("csrf-token")
        },
        body: JSON.stringify({
          tmdb_id: this.idValue,
          title: this.titleValue,
          image_url: this.imageUrlValue,
          media_type: this.mediaTypeValue
        })
      });

      if (response.ok) {
        const data = await response.json();
        this.updateFavoriteUI(data.favorited);
        this.dispatchToggleEvent(data.favorited);
      } else {
        console.error("Erreur lors de la demande de basculement des favoris.");
      }
    } catch (error) {
      console.error("Une erreur s'est produite lors de la demande de basculement des favoris.", error);
    }
  }

  updateFavoriteUI(favorited) {
    const checkboxId = `favorite-checkbox-${this.idValue}`;
    const checkboxBackId = `favorite-checkbox-back-${this.idValue}`;

    if (favorited) {
      document.getElementById(checkboxId).checked = true;
      document.getElementById(checkboxBackId).checked = true;
    } else {
      document.getElementById(checkboxId).checked = false;
      document.getElementById(checkboxBackId).checked = false;
    }
  }

  dispatchToggleEvent(favorited) {
    const event = new CustomEvent("favorite:toggle", {
      bubbles: true,
      detail: { favorited }
    });

    this.element.dispatchEvent(event);
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}

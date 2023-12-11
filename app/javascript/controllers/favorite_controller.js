import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: Number, title: String, imageUrl: String, mediaType: String }

  connect() {
    this.checkbox = document.getElementById(`favorite-checkbox-${this.idValue}`);
    this.checkboxBack = document.getElementById(`favorite-checkbox-back-${this.idValue}`);
  }

  async toggle(event) {
    event.preventDefault();

    const currentlyFavorited = this.checkbox.checked;

    this.updateFavoriteUI(!currentlyFavorited);

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

      if (!response.ok) throw new Error("Request failed");

      const data = await response.json();
      if (data.favorited !== !currentlyFavorited) {
        this.updateFavoriteUI(currentlyFavorited);
      }
      this.dispatchToggleEvent(data.favorited);
    } catch (error) {
      this.updateFavoriteUI(currentlyFavorited);
      console.error("Une erreur s'est produite lors de la demande de basculement des favoris.", error);
    }
  }

  updateFavoriteUI(favorited) {
    this.checkbox.checked = favorited;
    this.checkboxBack.checked = favorited;
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

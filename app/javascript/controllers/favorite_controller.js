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
      } else {
        console.error("Erreur lors de la demande de basculement des favoris.");
      }
    } catch (error) {
      console.error("Une erreur s'est produite lors de la demande de basculement des favoris.", error);
    }
  }

  // Méthode pour mettre à jour l'icône du cœur et la classe CSS
  updateFavoriteUI(favorited) {
    const icon = this.element.querySelector('.heart-icon');
    icon.src = favorited ? "heart_full.svg" : "heart_empty.svg";

    if (favorited) {
      this.element.classList.add('favorited');
    } else {
      this.element.classList.remove('favorited');
    }
  }


  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}

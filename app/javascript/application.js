// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "@fortawesome/fontawesome-free";


document.addEventListener("turbo:load", () => {
  document.body.addEventListener("favorite:toggle", (event) => {
    const controller = event.target.closest("[data-controller='favorite']");
    if (controller) {
      const { favorited } = event.detail;
      updateFavoriteButtonUI(controller, favorited);
    }
  });
});

function updateFavoriteButtonUI(controller, favorited) {
  if (!controller.checkbox || !controller.checkboxBack) {
    controller.checkbox = document.getElementById(`favorite-checkbox-${controller.idValue}`);
    controller.checkboxBack = document.getElementById(`favorite-checkbox-back-${controller.idValue}`);
  }

  controller.checkbox.checked = favorited;
  controller.checkboxBack.checked = favorited;
}

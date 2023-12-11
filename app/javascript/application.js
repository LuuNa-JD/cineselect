// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "@fortawesome/fontawesome-free";


document.addEventListener("turbo:load", () => {
  document.body.addEventListener("favorite:toggle", (event) => {
    const controllerElement = event.target.closest("[data-controller='favorite']");
    if (controllerElement) {
      const controller = {
        idValue: controllerElement.getAttribute('data-favorite-id-value'),
        checkbox: document.getElementById(`favorite-checkbox-${controllerElement.getAttribute('data-favorite-id-value')}`),
        checkboxBack: document.getElementById(`favorite-checkbox-back-${controllerElement.getAttribute('data-favorite-id-value')}`)
      };
      const favorited = event.detail.favorited;
      updateFavoriteButtonUI(controller, favorited);
    }
  });
});

function updateFavoriteButtonUI(controller, favorited) {
  if (controller.checkbox && controller.checkboxBack) {
    controller.checkbox.checked = favorited;
    controller.checkboxBack.checked = favorited;
  } else {
    console.error('Checkbox elements not found for:', controller.idValue);
  }
}

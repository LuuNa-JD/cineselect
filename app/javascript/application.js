// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "@fortawesome/fontawesome-free";


document.addEventListener("turbo:load", () => {
  const favoritesControllers = document.querySelectorAll("[data-controller='favorite']");

  favoritesControllers.forEach((controller) => {
    controller.addEventListener("favorite:toggle", (event) => {
      const { favorited } = event.detail;


      const otherFavoritesControllers = document.querySelectorAll("[data-controller='favorite']:not(.controller-uuid-" + controller.dataset.uuid + ")");

      otherFavoritesControllers.forEach((otherController) => {
        otherController.querySelector("input[type='checkbox']").checked = favorited;
      });
    });
  });
});

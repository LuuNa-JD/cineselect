import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.setupHammer();
  }

  setupHammer() {
    const card = this.element;
    const cardInner = card.querySelector('.card-inner');
    const mc = new Hammer(card);

    mc.on("doubletap", () => {
      cardInner.classList.toggle('is-flipped');
    });

    mc.on("panleft", function(ev) {
      if (Math.abs(ev.deltaX) > 100) {
        card.style.transition = 'transform 0.7s ease-out';
        card.style.transform = 'translateX(-120%)';
        setTimeout(() => {
          card.classList.add('hide-out');
          var url = card.getAttribute('data-url');
          window.location.href = url;
        }, 300);
      }
    });

    mc.on("panright", function(ev) {
      if (ev.deltaX > 100) {
        card.style.transition = 'transform 0.7s ease-out';
        card.style.transform = 'translateX(120%)';
        setTimeout(() => {
          card.classList.add('hide');
        }, 300);

      }
    });

    mc.on("pan", function(ev) {
      if (Math.abs(ev.deltaX) < window.innerWidth) {
        card.style.transform = `translateX(${ev.deltaX}px)`;
      }
    });

    mc.on("panend", function(ev) {
      if (ev.deltaX <= 100) {
        card.style.transition = 'transform 0.3s ease-out';
        card.style.transform = '';
      }
    });
  }
}

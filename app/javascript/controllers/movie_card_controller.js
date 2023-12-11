import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['movieCard'];

  initialize() {
    console.log("Contrôleur Stimulus initialisé");
    document.addEventListener('turbo:load', () => {
      console.log("Turbo Frames a chargé le contenu");
      this.loadHammerAndSetup();
    });
  }

  connect() {
    this.cardsSwiped = 0;
    this.totalCards = this.movieCardTargets.length;
  }

  async loadHammerAndSetup() {
    try {
      await this.loadScript('https://cdnjs.cloudflare.com/ajax/libs/hammer.js/2.0.8/hammer.min.js');
      this.setupHammer();
    } catch (error) {
      console.error("Impossible de charger Hammer.js", error);
    }
  }

  loadScript(url) {
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = url;
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }

  setupHammer() {
    const card = this.element;
    const cardInner = card.querySelector('.card-inner');
    const mc = new Hammer(card);

    mc.on("doubletap", () => {
      cardInner.classList.toggle('is-flipped');
    });

    mc.on("panleft", (ev) => {
      this.handleSwipeLeft(ev, card);
    });

    mc.on("panright", (ev) => {
      this.handleSwipeRight(ev, card);
    });

    mc.on("pan", (ev) => {
      if (Math.abs(ev.deltaX) < window.innerWidth) {
        card.style.transition = 'none';
        card.style.transform = `translate3d(${ev.deltaX}px, 0, 0)`;
      }
    });

    mc.on("panend", (ev) => {
      if (Math.abs(ev.deltaX) <= 100) {
        card.style.transition = 'transform 0.4s ease-out';
        card.style.transform = '';
      }
    });
  }

  handleSwipeLeft(ev, card) {
    const swipeThreshold = -100;
    if (ev.deltaX < swipeThreshold) {
      card.style.transition = 'transform 0.4s ease-out';
      card.style.transform = 'translateX(-120%)';
      setTimeout(() => {
        card.classList.add('hide');
        this.cardsSwiped++;
        this.removeCardFromDOM(card);
      }, 300);
    }
  }

  handleSwipeRight(ev, card) {
    const swipeThreshold = 100;
    if (ev.deltaX > swipeThreshold) {
      card.style.transition = 'transform 0.4s ease-out';
      card.style.transform = 'translateX(120%)';
      setTimeout(() => {
        card.classList.add('hide-out');
        var url = card.getAttribute('data-url');
        window.location.href = url;
      }, 300);
    }
  }

  removeCardFromDOM(card) {
    if (card && card.parentNode) {
      card.parentNode.removeChild(card);
    }
  }
}

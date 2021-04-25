import { Modal } from "tailwindcss-stimulus-components";

export default class extends Modal {
  static targets = ['container'];

  connect() {
    super.connect();
  }

  open(e) {
    if (this.preventDefaultActionOpening) {
      e.preventDefault();
    }

    e.target.blur();

    // Lock the scroll and save current scroll position
    this.lockScroll();

    // Unhide the modal
    document.addEventListener("taskForm:load", () => {
      this.containerTarget.classList.remove(this.toggleClass);
    });

    // Insert the background
    if (!this.data.get("disable-backdrop")) {
      document.body.insertAdjacentHTML('beforeend', this.backgroundHtml);
      this.background = document.querySelector(`#${this.backgroundId}`);
    }
  }
}

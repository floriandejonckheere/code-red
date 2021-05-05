import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['menu', 'title', 'value', 'button']

  static values = {
    // Dropdown state
    open: Boolean,
  }

  toggle() {
    this.openValue = !this.openValue
  }

  hide(event) {
    if (this.element.contains(event.target) === false && this.openValue) {
      this.openValue = false
    }
  }

  set(e) {
    // Set hidden form input
    this.valueTarget.value = e.currentTarget.dataset.value

    // Set dropdown
    this.titleTarget.innerHTML = e.currentTarget.dataset.title || e.currentTarget.innerHTML

    // Dispatch change event, so autosave triggers
    this.valueTarget.dispatchEvent(new Event('change'))
  }

  openValueChanged() {
    this.openValue ? this._show() : this._hide()
  }

  _show() {
    setTimeout(() => {
      this.menuTarget.classList.remove('hidden')
      this.buttonTarget.classList.add('bg-gray-100')
    })
  }

  _hide() {
    setTimeout(() => {
      this.menuTarget.classList.add('hidden')
      this.buttonTarget.classList.remove('bg-gray-100')
    })
  }
}

import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['menu', 'title', 'value']

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
    })
  }

  _hide() {
    setTimeout(() => {
      this.menuTarget.classList.add('hidden')
    })
  }
}

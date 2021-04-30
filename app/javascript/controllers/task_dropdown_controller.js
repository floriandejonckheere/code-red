import { Dropdown } from "tailwindcss-stimulus-components";

export default class extends Dropdown {
  static targets = ['menu', 'button', 'title', 'value']

  set(e) {
    // Set hidden form input
    this.valueTarget.value = e.currentTarget.dataset.value

    // Set dropdown
    this.titleTarget.innerHTML = e.currentTarget.innerHTML

    // Dispatch change event, so autosave triggers
    this.valueTarget.dispatchEvent(new Event("change"))
  }
}

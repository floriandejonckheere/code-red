import { Dropdown } from "tailwindcss-stimulus-components";

export default class extends Dropdown {
  static targets = ['menu', 'button', 'title', 'value']

  set(e) {
    this.valueTarget.value = e.target.dataset.value
    this.titleTarget.innerHTML = e.target.innerHTML
  }
}

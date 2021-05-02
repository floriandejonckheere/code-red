import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["container"]

  connect() {
    super.connect()

    fetch("/tasks.json")
      .then(response => response.json())
      .then(json => {
        new window.sigma({
          graph: json,
          renderer: {
            container: this.containerTarget,
            type: "svg",
          },
          settings: {
            defaultNodeColor: "#ec5148",
          },
        })
      })
  }
}

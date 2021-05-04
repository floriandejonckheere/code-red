import { Controller } from "stimulus"
import Quill from "quill"

// Based on https://mattsears.com/articles/2021/01/26/creating-a-simple-rich-text-editor-with-quill-stimulus-and-tailwind-css/
export default class extends Controller {
  static targets = ["container", "hidden", "toolbar", "form"]

  connect() {
    this.quillInit()
  }

  quillInit() {
    const quill = new Quill(this.containerTarget, this.quillOption)
    let _this = this

    quill.on("text-change", function(delta) {
      _this.hiddenTarget.value = quill.root.innerHTML
    })
  }

  get quillOption() {
    return {
      modules: {
        toolbar: this.toolbarTarget
      },
    }
  }
}

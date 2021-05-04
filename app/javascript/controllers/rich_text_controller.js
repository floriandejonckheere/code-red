import { Controller } from 'stimulus'
import Quill from 'quill'

// Based on https://mattsears.com/articles/2021/01/26/creating-a-simple-rich-text-editor-with-quill-stimulus-and-tailwind-css/
export default class extends Controller {
  static targets = ['container', 'hidden', 'toolbar', 'form']

  connect() {
    this.quillInit()
  }

  quillInit() {
    const quill = new Quill(this.containerTarget, this.quillOption)
    let self = this

    quill.on('text-change', function(delta) {
      self.hiddenTarget.value = quill.root.innerHTML

      // Dispatch change event, so autosave triggers
      self.hiddenTarget.dispatchEvent(new Event('change'))
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

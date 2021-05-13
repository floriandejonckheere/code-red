import { Controller } from 'stimulus'
import Quill from 'quill'

// Based on https://mattsears.com/articles/2021/01/26/creating-a-simple-rich-text-editor-with-quill-stimulus-and-tailwind-css/
export default class extends Controller {
  static targets = ['container', 'hidden', 'toolbar']

  quill = null

  connect() {
    this.quillInit()
  }

  quillInit() {
    this.quill = new Quill(this.containerTarget, this.quillOption)
    let self = this

    this.quill.on('text-change', function(delta) {
      self.hiddenTarget.value = self.quill.root.innerHTML

      // Dispatch change event, so autosave triggers
      self.hiddenTarget.dispatchEvent(new Event('change'))
    })
  }

  undo() {
    this.quill.history.undo()
  }

  redo() {
    this.quill.history.redo()
  }

  get quillOption() {
    return {
      modules: {
        toolbar: this.toolbarTarget,
        history: {
          delay: 1000,
          maxStack: 100,
          userOnly: false
        },
      },
    }
  }
}

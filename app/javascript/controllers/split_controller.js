import { Controller } from "@hotwired/stimulus"
import Split from "split.js"
import "~/stylesheets/split.css"

export default class extends Controller {
  static values = {
    elements: Array,
    rightId: String,
    sizes: { type: Array, default: [] },
    minSize: { type: Array, default: [100, 100] },
    maxSize: { type: Array, default: [Infinity, Infinity] },
    snapOffset: { type: Number, default: 30 },
    dragInterval: { type: Number, default: 10 },
    gutterSize: { type: Number, default: 10 },
  }

  connect() {
    this.split = Split(this.elementsValue, {
      sizes: this.sizesValue,
      minSize: this.minSizeValue,
      maxSize: this.maxSizeValue,
      snapOffset: this.snapOffsetValue,
      dragInterval: this.dragIntervalValue,
      gutterSize: this.gutterSizeValue,
    })
  }

  disconnect() {
    this.split.destroy()
    super.disconnect()
  }
}

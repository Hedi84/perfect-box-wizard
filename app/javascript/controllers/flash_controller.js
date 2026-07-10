import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dismissAfter: Number }

  connect() {
    if (this.dismissAfterValue > 0) {
      this.timeout = setTimeout(() => this.close(), this.dismissAfterValue)
    }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  close() {
    this.element.remove()
  }
}

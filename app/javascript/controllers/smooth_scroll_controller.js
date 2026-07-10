import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll(event) {
    const href = event.currentTarget.getAttribute("href")
    if (!href || !href.startsWith("#")) return

    const target = document.querySelector(href)
    if (!target) return

    event.preventDefault()
    target.scrollIntoView({ behavior: "smooth" })
  }
}

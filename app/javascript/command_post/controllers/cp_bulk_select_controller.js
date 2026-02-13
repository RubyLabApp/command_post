import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar", "count", "selectAll", "checkbox"]

  toggleAll() {
    const checked = this.selectAllTarget.checked
    this.checkboxTargets.forEach((cb) => { cb.checked = checked })
    this.updateBar()
  }

  toggle() {
    const total = this.checkboxTargets.length
    const checked = this.checkboxTargets.filter((cb) => cb.checked).length
    this.selectAllTarget.checked = checked === total && total > 0
    this.updateBar()
  }

  updateBar() {
    const checked = this.checkboxTargets.filter((cb) => cb.checked).length
    this.barTarget.style.display = checked > 0 ? "flex" : "none"
    this.countTarget.textContent = checked
  }
}

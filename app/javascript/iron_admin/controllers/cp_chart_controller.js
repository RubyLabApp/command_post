import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = { config: Object }

  connect() {
    if (typeof Chart !== "undefined") {
      this.initChart()
    } else {
      this.boundInit = () => this.initChart()
      document.addEventListener("chartjs:loaded", this.boundInit)
    }
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
    if (this.boundInit) {
      document.removeEventListener("chartjs:loaded", this.boundInit)
    }
  }

  initChart() {
    if (!this.hasCanvasTarget) return
    this.chart = new Chart(this.canvasTarget, this.configValue)
  }
}

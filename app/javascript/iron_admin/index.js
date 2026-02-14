import CpBulkSelectController from "iron_admin/controllers/cp_bulk_select_controller"
import CpChartController from "iron_admin/controllers/cp_chart_controller"

const application = window.Stimulus
application.register("cp-bulk-select", CpBulkSelectController)
application.register("cp-chart", CpChartController)

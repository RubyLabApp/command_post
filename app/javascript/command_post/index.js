import CpBulkSelectController from "command_post/controllers/cp_bulk_select_controller"
import CpChartController from "command_post/controllers/cp_chart_controller"

const application = window.Stimulus
application.register("cp-bulk-select", CpBulkSelectController)
application.register("cp-chart", CpChartController)

import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Canvas from "./canvas"
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const params = { _csrf_token: csrfToken }
const hooks = { Canvas }
let liveSocket = new LiveSocket("/live", Socket, { params, hooks })

topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.delayedShow(200))
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket


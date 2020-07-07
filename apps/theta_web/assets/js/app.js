// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}
Hooks.Dir = {
	mounted() {
		let datatest = this.el.dataset.dir;
		console.log(datatest);
		this.el.addEventListener("dblclick", e => {
			let data = this.el.dataset.dir;
			console.log(data);
			this.pushEvent("into", {dir: data})
		})
	}
}
Hooks.File = {
	mounted() {
		let datatest = this.el.dataset.file;
		console.log(datatest);
		this.el.addEventListener("dblclick", e => {
			let data = this.el.dataset.file;
			let url = this.el.dataset.url;
			console.log(data);
			console.log(url);
			window.opener.document.getElementById('imgSelect').value = '/' + url + '/' + data;
			// this.pushEvent("select", {file: data})
			window.close();
		})
	}
}
Hooks.Upload = {
	mounted() {

		this.el.addEventListener("reset", e => {
			let data = this.el;
			console.log(data.q.files[0]);
			var formData = new FormData();
			let fileData = data.q.files[0];
			formData.append('fileUpload', fileData);
			fetch("/api/upload",
					{
						method: "POST",
						body: formData,
					})
					.then(function (res) {
						let re = res.json()
						return re;
					})
			this.pushEvent("into", {dir: "2020"})
			this.pushEvent("into", {dir: "7"})
			this.pushEvent("change", {page: "refresh"})
		})
	}
}
let liveSocket = new LiveSocket("/live", Socket, {
	hooks: Hooks,
	params: {_csrf_token: csrfToken},
	// metadata: {
	// 	click: (e, el) => {
	// 		return {
	// 			altKey: e.altKey,
	// 			clientX: e.clientX,
	// 			clientY: e.clientY
	// 		}
	// 	}
	// }
})
import "../css/custom_bulma.scss";

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

// Bulma navbar
document.addEventListener('DOMContentLoaded', () => {

	// Get all "navbar-burger" elements
	const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

	// Check if there are any navbar burgers
	if ($navbarBurgers.length > 0) {

		// Add a click event on each of them
		$navbarBurgers.forEach(el => {
			el.addEventListener('click', () => {

				// Get the target from the "data-target" attribute
				const target = el.dataset.target;
				const $target = document.getElementById(target);

				// Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
				el.classList.toggle('is-active');
				$target.classList.toggle('is-active');

			});
		});
	}

});


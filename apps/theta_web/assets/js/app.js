// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";
import "../css/back.sass";

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
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let Hooks = {}
Hooks.Dir = {
  mounted() {
    let datatest = this.el.dataset.dir;
    // console.log(this.el.id);
    this.el.addEventListener("dblclick", e => {
      let data = this.el.dataset.dir;
      // console.log(data);
      this.pushEvent("into", {dir: data})
    })
  }
}
Hooks.File = {
  mounted() {
    let queryString = window.location.search;
    // let c = url.searchParams.get("id");
    // console.log(queryString);
    let urlParams = new URLSearchParams(queryString);
    let id = urlParams.get('id')
    console.log(id);
    let datatest = this.el.dataset.file;
    // console.log(datatest);
    this.el.addEventListener("dblclick", e => {
      let data = this.el.dataset.file;
      let url = this.el.dataset.url;
      // console.log(data);
      // console.log(url);
      window.opener.document.getElementById(id).value = '/' + url + '/' + data;
      // this.pushEvent("select", {file: data})
      window.close();
    })
  }
}
Hooks.Upload = {
  mounted() {
    this.el.addEventListener("reset", e => {
      let page = this;
      let data = this.el;

      var formData = new FormData();
      let fileData = data.q.files[0];
      let url = data.u.value;
      let token = this.el.id;
      formData.append('fileUpload', fileData);
      formData.append('uriUpload', url);
      // console.log(data.q.files[0]);
      //  console.log('Bearer ' + token);
      fetch("/api/upload",
              {
                credentials: 'same-origin', // include, *same-origin, omit
                method: "POST",
                body: formData,
                headers: {
                  'Authorization': 'Bearer ' + token
                }
              })
              .then(response => response.json())
              .then(function (_) {
                page.pushEvent("change", {page: "refresh"})
              })


    })
  }
}
Hooks.Top = {
  mounted() {
    this.el.addEventListener("click", e => {
      window.opener.document.getElementById('imgSelect').value = '/' + url + '/' + data;
      // this.pushEvent("select", {file: data})

    })
  }
}
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: {_csrf_token: csrfToken},
})


// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
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


  //Get the button:
  let topbutton = document.getElementById("topBtn");

  // When the user scrolls down 20px from the top of the document, show the button
  // window.onscroll = function () {
  //   scrollFunction()
  // };
  //
  // function scrollFunction() {
  //   if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
  //     topbutton.style.display = "block";
  //   } else {
  //     topbutton.style.display = "none";
  //   }
  // }

  // topbutton.addEventListener("click", topFunction);

  // When the user clicks on the button, scroll to the top of the document
  function topFunction() {
    document.body.scrollTop = 0; // For Safari
    document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  }

  // Upload file
  let imgUpload = document.getElementsByClassName("file-input");
  for (let i = 0; i < imgUpload.length; i++) {
    imgUpload[i].addEventListener('click', uploadFunction, false);
  }

  function uploadFunction() {
    console.log(this.id);
    let host = window.location.host;
    let protocol = window.location.protocol;
    let url = protocol + "//" + host + "/admin/media-live?id=" + this.id;
    window.open(
            url,
            "DescriptiveWindowName",
            "resizable,status"
    );
  }

});


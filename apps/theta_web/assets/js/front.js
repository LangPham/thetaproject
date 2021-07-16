import "../css/front.sass";
import Alpine from 'alpinejs'

// Bulma navbar
document.addEventListener('DOMContentLoaded', () => {
  window.Alpine = Alpine;

  Alpine.start();
  // Alpine.data('main_menu', () => ({
  //
  // 	is_laptop: is_laptop,
  // 	menu_state: false,
  // 	dropdown_state: {},
  //
  // 	click_menu() {
  //
  // 		this.menu_state = !this.menu_state || is_laptop;
  // 	},
  // 	click_dropdown(id) {
  // 		console.log(this.dropdown_state);
  //
  // 	},
  // 	init() {
  // 		this.menu_state = false || is_laptop;
  // 	}
  // }))


  // window.Alpine = Alpine;
  // window.Alpine.start();


  // ALPINE ===============================================================|^|

  function check_webp_feature(feature, callback) {
    var kTestImages = {
      lossy: "UklGRiIAAABXRUJQVlA4IBYAAAAwAQCdASoBAAEADsD+JaQAA3AAAAAA",
      lossless: "UklGRhoAAABXRUJQVlA4TA0AAAAvAAAAEAcQERGIiP4HAA==",
      alpha: "UklGRkoAAABXRUJQVlA4WAoAAAAQAAAAAAAAAAAAQUxQSAwAAAARBxAR/Q9ERP8DAABWUDggGAAAABQBAJ0BKgEAAQAAAP4AAA3AAP7mtQAAAA==",
      animation: "UklGRlIAAABXRUJQVlA4WAoAAAASAAAAAAAAAAAAQU5JTQYAAAD/////AABBTk1GJgAAAAAAAAAAAAAAAAAAAGQAAABWUDhMDQAAAC8AAAAQBxAREYiI/gcA"
    };
    var img = new Image();
    img.onload = function () {
      var result = (img.width > 0) && (img.height > 0);
      callback(feature, result);
    };
    img.onerror = function () {
      callback(feature, false);
    };
    img.src = "data:image/webp;base64," + kTestImages[feature];
  }

  check_webp_feature('lossy', function (feature, isSupported) {
    let body = document.getElementsByTagName("body");
    if (isSupported) {
      body[0].classList.add("webp");
    } else {
      body[0].classList.add("no-webp");
    }
  });

  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.hamburger'), 0);

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


  // //Get the button:
  // let topbutton = document.getElementById("topBtn");
  //
  // // When the user scrolls down 20px from the top of the document, show the button
  // window.onscroll = function () {
  //   scrollFunction()
  // };
  //
  // function scrollFunction() {
  //   if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
  //     topbutton.style.visibility = "visible";
  //     topbutton.style.opacity = "1";
  //   } else {
  //     topbutton.style.visibility = "hidden";
  //     topbutton.style.opacity = "0";
  //   }
  // }

  //
  // topbutton.addEventListener("click", topFunction);
  //
  // // When the user clicks on the button, scroll to the top of the document
  // function topFunction() {
  //   document.body.scrollTop = 0; // For Safari
  //   document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
  // }

});


import "../css/tailwind.pcss";
// import Alpine from 'alpinejs'

document.addEventListener('DOMContentLoaded', () => {
    let is_laptop = false;
    if (window.innerWidth > 1023) {
        is_laptop = true;
    }

    // Alpine.data('main_menu', () => ({
    //     is_laptop: is_laptop,
    //     menu_state: false,
    //     dropdown_state: {},
    //     click_menu() {
    //         this.menu_state = !this.menu_state || is_laptop;
    //     },
    //     init() {
    //         this.menu_state = false || is_laptop;
    //
    //     }
    // }))
    //
    // window.Alpine = Alpine;
    //
    // Alpine.start();

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
        let main = document.getElementsByTagName("main");
        if (isSupported) {
            main[0].style.backgroundImage = "url(/images/bg.webp)";
        } else {
            main[0].style.backgroundImage = "url(/images/bg.png)";
        }
    });

    //Button TOP:
    if (!!document.getElementById("topBtn")){
        let topBtn = document.getElementById("topBtn");
        window.onscroll = function () {
            if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                topBtn.style.display = "block";
            } else {
                topBtn.style.display = "none";
            }
        };
        topBtn.addEventListener("click", function (){
            document.body.scrollTop = 0; // For Safari
            document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
        });
    }

    // Hamburger
    if (!!document.getElementById("hamburger")){
        let hamburger = document.getElementById("hamburger");
        hamburger.addEventListener("click", function (){
            hamburger.classList.toggle("is-active");
            let menu = document.getElementById(hamburger.dataset.target);
            menu.classList.toggle("-translate-x-full");
        })



    }

});


(function() {
    var css = ".d-flex.align-items-center.me-auto {display: none !important;} .nav-link.navigation-link {display: none !important;} #search-button {display: none !important;} #chat_dropdown {display: none !important;} .navbar-search.visible-xs {display: none !important;} html,body{background:#111!important;color:#fff!important}.topic-header{background:#111!important}span,.badge,.pointer{color:#fff!important}.wrapper,.handle{background:#222!important}.composer-container,textarea{background:#111!important}textarea{color:#fff!important}.resizer{background:transparent!important}.avatar{box-shadow:0 0 0 4px #333!important}blockquote{background-color:#222!important}#header-menu{background-color:#111!important}.nav-link{color:#fff!important}li{color:white!important}p{color:white!important}a{color:#19b6ee}button:not(:disabled){color:white!important}.btn-link{--bs-btn-color:#19b6ee}.btn:hover{background-color:#333}textarea::placeholder{color:#ccc!important}:root{--btn-ghost-hover-color:#222;--btn-ghost-active-color:#333;--bs-carousel-indicator-active-bg:#111;--bs-carousel-caption-color:#111;--bs-body-bg:#111;--bs-tertiary-bg:#333;--bs-border-color:#666}input::placeholder{color:white!important}code{background:#333!important;color:#fff!important}.modal-content{background-color:#111!important;color:white!important}.dropdown-menu{--bs-dropdown-bg:#111!important;--bs-dropdown-link-color:#fff}.dropdown-item:hover{background-color:#333;color:#ccc!important}.card-body{background:#222!important}.form-select{background-color:#111!important;color:white!important}.form-control{color:white!important;background-color:#222}.text-body{color:white!important}.tag-list .tag{background:#111!important;color:white!important}";
    
    if (typeof GM_addStyle != "undefined") {
        GM_addStyle(css);
    } else if (typeof PRO_addStyle != "undefined") {
        PRO_addStyle(css);
    } else if (typeof addStyle != "undefined") {
        addStyle(css);
    } else {
        var node = document.createElement("style");
        node.type = "text/css";
        node.appendChild(document.createTextNode(css));
        var heads = document.getElementsByTagName("head");
        if (heads.length > 0) {
            heads[0].appendChild(node);
        } else {
            document.documentElement.appendChild(node);
        }
    }
})();
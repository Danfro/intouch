(function() {
    var css = ".d-flex.align-items-center.me-auto {display: none !important;} .nav-link.navigation-link {display: none !important;} #search-button {display: none !important;} #chat_dropdown {display: none !important;} .navbar-search.visible-xs {display: none !important;}";
    
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
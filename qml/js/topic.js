(function() {
    var css = "#header-menu {display: none !important;}.topic .topic-header {top: 0px !important;}.topic-title.d-flex {display: none !important}.btn.btn-sm.btn-ghost {display: none !important}.btn.btn-sm.btn-primary.dropdown-toggle {display: none !important}.alert-window {display: none !important;}";

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
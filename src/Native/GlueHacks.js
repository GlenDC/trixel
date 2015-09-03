Elm.Native.GlueHacks = Elm.Native.GlueHacks || {};
Elm.Native.GlueHacks.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.GlueHacks = elm.Native.GlueHacks || {};
    if (elm.Native.GlueHacks.values) return elm.Native.GlueHacks.values;

    function getViewportDimensions(id) {
        var viewport = document.getElementById(id);
        if(viewport) {
            return {
                x: viewport.offsetWidth,
                y: viewport.offsetHeight
            };
        }

        return {x: 0, y: 0};
    }

    return elm.Native.GlueHacks.values = {
        getViewportDimensions: getViewportDimensions,
    };
};

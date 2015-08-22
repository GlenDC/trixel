Elm.Native.GlueRandom = Elm.Native.GlueRandom || {};
Elm.Native.GlueRandom.make = function(elm) {
    elm.Native = elm.Native || {};
    elm.Native.GlueRandom = elm.Native.GlueRandom || {};
    if (elm.Native.GlueRandom.values) return elm.Native.GlueRandom.values;

    function randomFloat(min, max) {
        return Math.random() * (max - min + 1) + min;
    }

    function randomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    return elm.Native.GlueRandom.values = {
        randomFloat: F2(randomFloat),
        randomInt: F2(randomInt) 
    };
};

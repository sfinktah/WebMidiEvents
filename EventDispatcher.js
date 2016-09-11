var EventDispatcher;
EventDispatcher = (function() {
    function EventDispatcher() {}

    EventDispatcher.prototype.removeEventListener = function(type, fn) {
        return bean.off(this, type, fn);
    };
    EventDispatcher.prototype.addEventListener = function(type, fn) {
        return bean.on(this, type, fn);
    };
    EventDispatcher.prototype.dispatchEvent = function(type, args) {
        try {
            if (type instanceof Object && type.type != null && typeof type.type === "string") {
                return bean.fire(this, type.type, type.msg);
            }
            if (typeof type != "string") {
                console.error("EventDispatcher.prototype.dispatchEvent: neither type nor type.type is valid", type);
            }
            return bean.fire(this, type, args);
        } catch (e) {
            console.log('Exception during dispatchEvent handler for', this);
            console.debug("e.message: " + e.message);
            console.debug("e.stack: " + e.stack);
        }

    };
    // EventDispatcher.prototype.dispatchEvent = bean.fire.bind(bean, this);

    return EventDispatcher;

})();

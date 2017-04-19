(function($){

    /**
     * Displays loading mask over selected element(s). Accepts both single and multiple selectors   
     * @param options the options to be used to display the mask
     * @example $('el').mask({spinner: false, label: 'Some Text'});
     * @example $('el').mask({spinner: { lines: 10, length: 4, width: 2, radius: 5}, delay: 100, label: 'Loading...'});
     */
     $.fn.mask = function(options) {
        if (typeof options == 'string' || options instanceof String) {
            options = $.extend({
                spinner: { lines: 10, length: 4, width: 2, radius: 5},
                spinnerPadding: 5,
                label: options,
                delay: 0,
                overlayOpacity: 0.75,
                overlaySize: false
            }, options);
        } else {
            options = $.extend({
                spinner: { lines: 10, length: 4, width: 2, radius: 5},
                spinnerPadding: 5,
                label: I18n.t("mask_loading_label") || "Loading...",
                delay: 0,
                overlayOpacity: 0.75,
                overlaySize: false
            }, options);    
        }
        return $(this).each(function() {
            var element = $(this);

            if(options.delay > 0) {
                element.data("_mask_timeout", setTimeout(function() { $.maskElement(element, options)}, options.delay));
            } else {
                $.maskElement(element, options);
            }
        });
    };
    
    /**
     * Removes mask from the element(s). Accepts both single and multiple selectors.
     */
     $.fn.unmask = function(){
        return $(this).each(function() {
            $.unmaskElement($(this));
        });
    };
    
    /**
     * Checks if a single element is masked. Returns false if mask is delayed or not displayed. 
     */
     $.fn.isMasked = function(){
        return this.hasClass("masked");
    };

    $.maskElement = function(element, options) {

        //if this element has delayed mask scheduled then remove it and display the new one
        if (element.data("_mask_timeout") !== undefined) {
            clearTimeout(element.data("_mask_timeout"));
            element.removeData("_mask_timeout");
        }

        if(element.isMasked()) {
            $.unmaskElement(element);
        }
        
        if(element.css("position") == "static") {
            element.addClass("masked-relative");
        }
        
        element.addClass("masked");
        
        var maskDiv = $('<div class="loadmask"></div>').css({
            opacity: 0,
            top: element.scrollTop()
        });

        if(options.overlaySize !== false) {
            if(options.overlaySize.height !== undefined)
                maskDiv.height(options.overlaySize.height)

            if(options.overlaySize.width !== undefined)
                maskDiv.width(options.overlaySize.width)
        }
        
        // auto height fix for IE
        if(navigator.userAgent.toLowerCase().indexOf("msie") > -1){
            maskDiv.height(element.height() + parseInt(element.css("padding-top")) + parseInt(element.css("padding-bottom")));
            maskDiv.width(element.width() + parseInt(element.css("padding-left")) + parseInt(element.css("padding-right")));
        }
        
        // fix for z-index bug with selects in IE6
        if(navigator.userAgent.toLowerCase().indexOf("msie 6") > -1){
            element.find("select").addClass("masked-hidden");
        }

        // Create spinner
        var spinner = new Spinner(options).spin(maskDiv[0]);

        // Create label
        if(options.label) {
            var label = document.createElement('div');
            label.innerHTML = '<b>'+options.label+'</b>';
            label.className = "loadmask-msg";
            spinner.el.append(label);
        }

        element.append(maskDiv);

        // TODO this should be customizable
        maskDiv.fadeTo('slow', options.overlayOpacity);
    };
    
    $.unmaskElement = function(element){
        //if this element has delayed mask scheduled then remove it
        if (element.data("_mask_timeout") !== undefined) {
            clearTimeout(element.data("_mask_timeout"));
            element.removeData("_mask_timeout");
        }
        
        element.find(".loadmask-msg,.loadmask").remove();
        element.removeClass("masked");
        element.removeClass("masked-relative");
        element.find("select").removeClass("masked-hidden");
    };

})(jQuery);
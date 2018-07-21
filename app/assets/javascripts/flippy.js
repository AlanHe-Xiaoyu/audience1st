// Attaches behaviors to any element with class .flippy and ID
//    'flippy_MODELNAME_ID' (eg flippy_order_251):
var Flippy = {
  getContentElementFor: function(elt) {
    // The element's ID has the form "flippy_MODELNAME_ID".
    // Get MODELNAME and ID, and use them to find the element whose
    // id is "details_MODELNAME_ID", which is the content shown/hidden
    // by the flippy.
    var matched = elt.attr('id').match(/^flippy_(\S+)_(\d+)$/);
    return($('#details_' + matched[1] + '_' + matched[2]));
  },
  toggle: function(flippy) {
    var flippyContent = Flippy.getContentElementFor(flippy).first();
    if (flippyContent.is(':visible')) {
      flippyContent.slideUp('fast');
      flippy.html('&#x25BA' + flippy.html().substr(1));
    } else {
      flippyContent.slideDown('fast');
      flippy.html('&#x25BC' + flippy.html().substr(1));
    }
  },
  handleClick: function(evt) {
    Flippy.toggle($(evt.target));
    return(false);
  },
  hideAll: function() {
    var flippies = $('.flippy');
    if (flippies.length > 1) {
      flippies.each(function(index,elt) { Flippy.toggle($(elt)); });
    }
  },
  setup: function() {
    $('.flippy').click(Flippy.handleClick);
    Flippy.hideAll();
  }
};
$(Flippy.setup);


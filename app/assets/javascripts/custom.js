$(function() {
  var $container = $('#container'), $hidden = $('#hidden');
  $container.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: 186
    }
  }).isotope('insert', $hidden.find('.item'));

  $('.item').click(function() {
    var $this = $(this),
        tileStyle = $this.hasClass('expanded') ?
          { width: 176, height: $this.height() / 2 } : { width: 352, height: $this.height() * 2 };
    $this.toggleClass('expanded');
    $this.find('.item-content').animate(tileStyle);
    $container.isotope('reLayout');
  });

  $('.item img').click(function() {
    $(this).animate({
      top: '-=' + $(this).height() / 2,
      left: '-=' + $(this).width() / 2,
      width: $(this).width() * 2
    });
  });
});

// Randomly color item divs
//$(function() {
  //$('.item-content').each(function() {
    //var randRGB = function() {
      //return Math.floor((256-199)*Math.random()) + 200;
    //},
    //hue = 'rgb(' + [randRGB(), randRGB(), randRGB()].join(',') + ')';
    //$(this).css('background-color', hue);
  //});
//});

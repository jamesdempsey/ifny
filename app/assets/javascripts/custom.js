$(function() {
  var $container = $('#container'), $hidden = $('#hidden'), $item = $('.item');

  $container.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: 186
    }
  }).isotope('insert', $hidden.find('.item'));

  $item.click(function() {
    var $this = $(this), $img = $this.find('img'),
        itemStyle = $this.hasClass('expanded') ?
          { width: 176, height: $this.height() / 2 } :
          { width: 528, height: $this.height() * 2 },
        imgStyle = $this.hasClass('expanded') ?
          { top: '+=' + $this.height() * 2,
            left: '+=' + $this.width() * 2,
            width: $this.width() / 2 } :
          { top: '-=' + $this.height() / 2,
            left: '-=' + $this.width() / 2,
            width: $this.width() * 2 };
        scrollTo = function() {
          $('html, body').animate({
            scrollTop: $this.offset().top - 40
          });
        };

    $this.toggleClass('expanded');
    $this.css(itemStyle);
    $img.animate(imgStyle);
    $this.find('.item-content').stop().animate(itemStyle, scrollTo);
    $container.isotope('reLayout', scrollTo);
  });
});

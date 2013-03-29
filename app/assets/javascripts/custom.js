$(function() {
  var $container = $('#container'), $hidden = $('#hidden');
  $container.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: 180
    }
  }).isotope('insert', $hidden.find('.item'));

// Randomly color item divs
$(function() {
  $('.item-content').each(function() {
    var randRGB = function() {
      return Math.floor((256-199)*Math.random()) + 200;
    },
    hue = 'rgb(' + [randRGB(), randRGB(), randRGB()].join(',') + ')';
    $(this).css('background-color', hue);
  });
});

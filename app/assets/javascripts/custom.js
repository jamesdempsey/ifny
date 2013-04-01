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
        $desc = $this.find('.item-description'),
        itemStyle = $this.hasClass('expanded') ?
          { width: 176, height: $this.height() / 2 } :
          { width: 704, height: $this.height() * 2 },
        imgStyle = $this.hasClass('expanded') ?
          { top: '+=' + $this.height() * 2,
            left: '+=' + $this.width() * 2,
            width: $this.width() / 2 } :
          { top: '-=' + $this.height() / 2,
            left: '-=' + $this.width() / 2,
            width: $this.width() * 2 },
        descStyle = $this.hasClass('expanded') ?
          { opacity: 0 } : { opacity: 1 },
        scrollTo = function() {
          $('html, body').animate({
            scrollTop: $this.offset().top - 45
          }, 200, 'linear');
        };

    $this.toggleClass('expanded');
    $desc.animate(descStyle);
    $this.css(itemStyle);
    $img.animate(imgStyle);
    $this.find('.item-content').stop().animate(itemStyle, scrollTo);
    $container.isotope('reLayout', scrollTo);
  });

  // WAYYYYY EXPERIMENTALLLLLL
  //
  // HERE WE GO
  //
  $('a.theater-name').click(function(e) {
    var $this = $(this), $film_showtimes = $this.closest('.film-showtimes'),
      $index = $this.closest('.film-showtimes-index');
    e.stopPropagation();
    e.preventDefault();
    $.getJSON($this.attr('href'), {film_id: $this.closest('.item').attr('id')},
      function(data) {
        var $showtimes = $.map(data.showtimes, function(showtime, index) {
          return showtime;
        }),
        $showtimes_theater = [
          '<div class="film-showtimes-theater"><ul><li>',
          $showtimes.join('</li><li>'), '</li></ul>',
          '<a href="#" class="back">Back</a></div>'
        ].join('');

        $index.animate({ opacity: 0}, function() {
          $film_showtimes.append($showtimes_theater);
          $('a.back').click(function(e) {
            var $this = $(this), $film_showtimes = $this.closest('.film-showtimes'),
              $theater = $film_showtimes.find('.film-showtimes-theater'),
              $index = $film_showtimes.find('.film-showtimes-index');

            e.stopPropagation();
            e.preventDefault();
            $theater.animate({ opacity: 0}, function() {
              $index.animate({ opacity: 1});
              $(this).remove();
            });
          });
          $film_showtimes.animate({ opacity: 1});
        });
      }
    );
  });
});

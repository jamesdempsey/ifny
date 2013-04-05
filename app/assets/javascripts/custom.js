$(function() {
  var $container = $('#container'),
    $hidden = $('#hidden'),
    $item = $('.item');

  $container.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: 186
    }
  }).isotope('insert', $hidden.find('.item'));

  $('a.theater-name').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
  });

  (function() {
    $.getJSON('/films', function(json) {
      $('a.theater-name').click(function(e) {
        var $this = $(this),
          $film_showtimes_div = $this.closest('.film-showtimes'),
          $film_showtimes_index_div = $this.closest('.film-showtimes-index'),
          $film_id = +$this.closest('.item').attr('id'),
          $theater_id = +$this.attr('href').match(/\d+/),
          $film = $.grep(json['films'], function(film) {
            return film.id == $film_id;
          })[0],
          $film_showtimes = $.map($film.showings, function(showing, i) {
            return showing.showtime;
          }),
          $truncated_film_showtimes = $film_showtimes.reduce(function(arr, e) {
            if ([arr.join(''), e].join('').length <= 160) {
              arr.push(e);
            };
            return arr;
          }, []);
          if ($truncated_film_showtimes.length != $film_showtimes.length) {
            $truncated_film_showtimes.push('...more');
          };
          var $showtimes_theater = [
            '<div class="film-showtimes-theater">',
            '<div class="title">', $this.text(), '</div>',
            '<ul><li>',
            $truncated_film_showtimes.join('</li><li>'),
            '</li></ul>',
            '<a href="#" class="back">Back</a></div>'
          ].join('');

        $film_showtimes_index_div.animate({ opacity: 0}, function() {
          $film_showtimes_div.append($showtimes_theater);
          $('a.back').click(function(e) {
            var $this = $(this),
              $film_showtimes_div = $this.closest('.film-showtimes'),
              $theater = $film_showtimes_div.find('.film-showtimes-theater'),
              $film_showtimes_index_div = $film_showtimes_div.find('.film-showtimes-index');

            e.stopPropagation();
            e.preventDefault();
            $theater.animate({ opacity: 0}, function() {
              $film_showtimes_index_div.animate({ opacity: 1});
              $(this).remove();
            });
          });

          $film_showtimes_div.animate({ opacity: 1}, 'slow');
        });
      });
    })
  })();

  $item.click(function() {
    var $this = $(this), $img = $this.find('img'),
        $desc = $this.find('.item-description'),
        expanded_height = $this.height() >= 176 ?
          $this.height() * 2 : $this.height() * 5,
        shrunk_height = $this.height() > 352 ?
          $this.height() / 2 : $this.height() / 5,
        itemStyle = $this.hasClass('expanded') ?
          { width: 176, height: shrunk_height } :
          { width: 704, height: expanded_height },
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
});

$(function() {
  var $container = $('#container'),
    $hidden = $('#hidden'),
    $item = $('.item'),
    $sort_buttons = $('#sort-by a'),

    // item container shrink function
    shrink = function(item) {
      var $desc = item.find('.item-description'),
        height = item.height() > 352 ? item.height() / 2 : item.height() / 5,
        itemStyle = { width: 176, height: height },
        descStyle = { opacity: 0 };

      item.removeClass('expanded');
      $desc.animate(descStyle);
      item.css(itemStyle);
      item.find('.item-content').stop().animate(itemStyle);
      item.on('click.expand', function() {
        expand(item);
      });
    },

    // item container scroll function
    scrollTo = function(item) {
      $('html, body').animate({
        scrollTop: item.offset().top - 45
      }, 75, 'linear');
    },

    // item container expand function
    expand = function(item) {
      var $desc = item.find('.item-description'),
        height = item.height() >= 176 ? item.height() * 2 : item.height() * 5,
        itemStyle = { width: 704, height: height },
        descStyle = { opacity: 1 };

      shrink($('.expanded'));
      item.addClass('expanded');
      $desc.animate(descStyle);
      item.css(itemStyle);
      item.find('.item-content').stop().animate(itemStyle);
      $container.isotope('reLayout');
      item.off('click.expand');
    };

  // Initialize isotope
  $container.isotope({
    itemSelector: '.item',
    masonry: {
      columnWidth: 186
    },
    animationEngine: 'jquery',
    onLayout: function($elems) {
      var item = $elems.filter('.expanded');

      if (item.hasClass('expanded')) {
        scrollTo(item);
      }
    },
    getSortData: {
      title: function($elem) {
        return $elem.find('.film-title').text();
      }
    }
  }).isotope('insert', $hidden.find('.item'));

  // sorting listeners
  $sort_buttons.click(function() {
    var $this = $(this), sortName = $this.attr('href').slice(1),
      sortType = sortName === 'shuffle' ? 'shuffle' : {sortBy: sortName}
    $sort_buttons.removeClass('active');
    $this.addClass('active');
    $container.isotope(sortType);
    return false;
  });

  // Catch theater name link clicks on dom ready
  $('a.theater-name').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
  });

  // self-executing .getJSON on dom ready to use for showtime divs
  // hookup theater name link clicks to .getJSON callback
  (function() {
    $.getJSON('/films', function(json) {
      $('a.theater-name').click(function() {
        var $this = $(this),
          $film_showtimes_div = $this.closest('.film-showtimes'),
          $film_showtimes_index_div = $this.closest('.film-showtimes-index'),
          $film_id = +$this.closest('.item').attr('id'),
          $film = $.grep(json.films, function(film) {
            return film.id === $film_id;
          })[0],
          $truncated_film_showtimes = $film.showings_by_date.reduce(function(arr, e) {
            if ([arr.join(''), e].join('').length <= 230) {
              arr.push(e);
            }
            return arr;
          }, []);

        if ($truncated_film_showtimes.length !== $film.showings_by_date.length) {
          $truncated_film_showtimes.push('...more');
        }

        var $showtimes_theater = [
          '<div class="film-showtimes-theater">',
          '<div class="title">', $this.text(), '</div>',
          '<ul><li>',
          $truncated_film_showtimes.join('</li><li>'),
          '</li></ul>',
          '<a href="#" class="back">Back</a></div>'
        ].join('');

        $film_showtimes_index_div.animate({opacity: 0}, function() {
          var $this = $(this);

          $film_showtimes_div.append($showtimes_theater);
          $('a.back').click(function(e) {
            var $this = $(this),
              $film_showtimes_div = $this.closest('.film-showtimes'),
              $theater = $film_showtimes_div.find('.film-showtimes-theater'),
              $film_showtimes_index_div = $film_showtimes_div.find('.film-showtimes-index');

            e.stopPropagation();
            e.preventDefault();
            $theater.animate({opacity: 0}, function() {
              $film_showtimes_index_div.animate({opacity: 1});
              $(this).remove();
            });
          });

          $this.next('.film-showtimes-theater').animate({opacity: 1});
        });
      });
    });
  }());

  // isotope item container click listener
  $item.on('click.expand', function() {
    expand($(this));
  });
});

import Turbolinks from 'turbolinks';
Turbolinks.start();
$(document).on('turbolinks:load', () => {
  let input = $('.search-field');
  input.on('keyup', function (e){
    if (e.keyCode == 13) {
      Turbolinks.visit('animes?name='+input.val())
      console.log('enter')
    }
    if (e.keyCode == 27) {
      input.val('')
      $('.search-results').html('')
    }
    search(input.val())
  })

  input.focusin(function () {
    search(input.val())
  })

  function search(value){
    if (value != "") {
      $.ajax({
        url: '/api/animes/search?name='+value,
        method: 'get',
        dataType: 'json',
        success: function (data) {

          const res = data.map(anime => "" +
            "<a href='/animes/"+anime.id+"'>" +
            "<div class='search-result'>" +
            "<div class='search-result-img'>" +
            "<img width='50px' src='https://animeon.ru/files/posters/animes/original/"+anime.id+".webp'>" +
            "</div>" +
            "<div class='search-result-name'>" +
            "<span>"+anime.russian+" / "+anime.name+"</span>" +
            "</div>" +
            "</div>" +
            "</a>").join('')
          $('.search-results').html(res)
        }
      })
    }
  }

})

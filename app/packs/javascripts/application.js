import Turbolinks from 'turbolinks';
import Playerjs from './playerjs.js';
Turbolinks.start();
$(document).on('turbolinks:load', () => {
  function Data() {
    const formData = new FormData();
    const file = $('#video_video_file')[0].files[0];
    formData.append('video[video_file]', file);
    formData.append('video[episode_id]', $('#ep-id').text());
    formData.append('video[fandub]', $('#video_fandub').val())
    formData.append('video[quality][]', $('#video_quality').val())
    return formData
  }

  $('.video_choose_button').on('click', function (e) {
    //$('#player-88955').remove()
    //$('.video_block').add('<div id="player-88955"></div>').appendTo( '.video_block' )
    $.ajax({
      url: '/api/videos/' + e.currentTarget.id + '',
      type: 'GET',
      data: null,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
      success: function (response) {
        set_new_player(response)
      },
      error: function (error) {
        console.log(error)
      }
    })

    //console.log(player);
  })

  function set_new_player(resp) {
    new window.Playerjs({id:"player", file: "[480]" + resp[0].url + ',[720]' + resp[1].url + ',[1080]' + resp[2].url});
  }

  $('.approve_changes').on('click', function (e) {
    $.ajax({
      url: '/api/db_modifications/' + e.currentTarget.id + '/approve',
      type: 'POST',
      data: null,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
      success: function (response) {
        $('#status-'+e.currentTarget.id).html(response.status)
      },
      error: function (error) {
        console.log(error)
      }
    })
  })
  $('.rollback_changes').on('click', function (e) {
    $.ajax({
      url: '/api/db_modifications/' + e.currentTarget.id + '/rollback',
      type: 'POST',
      data: null,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
      success: function (response) {
        $('#status-'+e.currentTarget.id).html(response.status)
      },
      error: function (error) {
        console.log(error)
      }
    })
  })
  $('.destroy_modification').on('click', function (e) {
    $.ajax({
      url: '/api/db_modifications/' + e.currentTarget.id,
      type: 'DELETE',
      data: null,
      processData: false,
      contentType: false,
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
      success: function (response) {
        $('tr#'+e.currentTarget.id).remove()
      },
      error: function (error) {
        console.log(error)
      }
    })
  })

  $('#btn-submit').on('click', function (e) {
    e.preventDefault();
    $('#btn-submit').prop({disabled: true})
    const formData = Data()
    if ($('#ep-id').attr('uploaded') == null) {
      $.ajax({
        url: '/api/videos',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        xhr: function () {
          const xhr = new window.XMLHttpRequest();
          xhr.upload.addEventListener("progress", function (evt) {
            if (evt.lengthComputable) {
              const percentComplete = Math.round((evt.loaded / evt.total) * 100);
              $('#progress-bar').css('width', percentComplete + '%');
              //console.log(evt)
            }
          }, false);
          return xhr;
        },
        success: function (response) {
          $('#progress-bar').css('background-color', 'green');
          $('#ep-id').attr({uploaded: response.video.id})
          $('#btn-submit').prop({disabled: false})
          $('#btn-save').css({visibility: 'visible'})
        },
        error: function () {
          $('#progress-bar').css('background-color', 'red');
          $('#btn-submit').prop({disabled: false})
        }
      });
    } else {
      $('#progress-bar').css('background-color', 'steelblue');
      $.ajax({
        url: '/api/videos/' + $('#ep-id').attr('uploaded'),
        type: 'PATCH',
        data: formData,
        processData: false,
        contentType: false,
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        xhr: function () {
          const xhr = new window.XMLHttpRequest();
          xhr.upload.addEventListener("progress", function (evt) {
            if (evt.lengthComputable) {
              const percentComplete = Math.round((evt.loaded / evt.total) * 100);
              $('#progress-bar').css('width', percentComplete + '%');
              //console.log(evt)
            }
          }, false);
          return xhr;
        },
        success: function (response) {
          $('#progress-bar').css('background-color', 'green');
          $('#ep-id').attr({uploaded: response.anime.id})
          $('#btn-submit').prop({disabled: false})
        },
        error: function () {
          $('#progress-bar').css('background-color', 'red');
          $('#btn-submit').prop({disabled: false})
        }
      });
    }
  });

  $('#btn-save').on('click', function (e) {
    e.preventDefault();
    //$('#btn-submit').prop({disabled: true})
    const formData = new FormData()
    formData.append('video[status]', 0)
    if ($('#ep-id').attr('uploaded') != null) {
      $.ajax({
        url: '/api/videos/' + $('#ep-id').attr('uploaded') + '/update_status',
        type: 'PATCH',
        data: formData,
        processData: false,
        contentType: false,
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        success: function (response) {
          console.log(response)
          Turbolinks.visit('/animes/' + response.anime.id + '/episodes/' + response.episode.id)
        },
        error: function () {
          $('#progress-bar').css('background-color', 'red');
          $('#btn-submit').prop({disabled: false})
        }
      })
    }
  })

  let input = $('.search-field');
  input.on('keyup', function (e){
    if (e.keyCode === 13) {
      Turbolinks.visit('/animes?name='+input.val())
      console.log('enter')
    }
    if (e.keyCode === 27) {
      input.val('')
      $('.search-results').html('')
    }
    search(input.val())
  })

  input.focusin(function () {
    search(input.val())
  })

  function search(value){
    if (value !== "") {
      $.ajax({
        url: '/api/animes/search?name='+value,
        method: 'get',
        dataType: 'json',
        success: function (data) {

          const res = data.map(anime => "" +
            "<a href='/animes/"+anime.id+"'>" +
            "<div class='search-result'>" +
            "<div class='search-result-img'>" +
            "<img width='50px' src='https://proxy.animeon.ru/files/posters/animes/original/"+anime.id+".webp'>" +
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

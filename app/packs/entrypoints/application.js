import '../../assets/stylesheets/application.sass'
import '../javascripts/application'
import 'chosen-js'
$(document).on('turbolinks:load', () => {
  $('.chosen-select').chosen({width: "50%"})
})

$(document).on('turbolinks:before-cache', () => {
  $('.chosen-select').chosen()
})

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  $('.pagination a').attr('data-remote', 'true')
  $('.custom_tooltip').tooltipster()
  if $(document).height() <= $(window).height()
    $("#footer").addClass("navbar-fixed-bottom")
    

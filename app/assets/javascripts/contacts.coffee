# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

filter_contacts = (pattern = "") ->
  $('.contacts .contact').each ->
    if $(this).data('filter').toLowerCase().indexOf(pattern.toLowerCase()) == -1
      $(this).hide()
    else
      $(this).show()
  $('#contacts_filter').focus()

$('#contacts_filter').bind 'input', ->
  filter_contacts $(this).val()

$('#clear_contacts_filter').bind 'click', ->
  $('#contacts_filter').val("")
  filter_contacts ""

filter_contacts $.cookie "saved_search_string"

$("a[data-view]").click (e) ->
  e.preventDefault()
  view = $(this).data('view')
  $(".view_buttons").each () ->
    $(this).removeClass("active")
  $(".view_buttons##{view}").addClass("active")
  $(".contacts").each () ->
    $(this).hide()
  $(".contacts##{view}").show()
  $.cookie "contacts_view", view

$("a[data-call]").click (e) ->
  e.preventDefault()
  $('#modal_alert').text "Пожалуйста, снимите трубку!"
  $('#modal_alert').foundation 'reveal', 'open'
  $.getJSON "/make_call/#{$(this).data('call')}.json", (data, status, xhr) ->
    $('#modal_alert').text data['message']
    $('#modal_alert').foundation 'reveal', 'open'
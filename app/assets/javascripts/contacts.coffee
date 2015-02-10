# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

filter_contacts = (pattern = "") ->
  $('#contacts_filter').val(pattern)
  $('.contacts .contact').each ->
    if $(this).data('filter').toLowerCase().indexOf(pattern.toLowerCase()) == -1
      $(this).hide()
    else
      $(this).show()

$('#contacts_filter').bind 'input', ->
  filter_contacts $(this).val()
  false

$("a[data-filter-contacts]").click (e) ->
  filter_contacts $(this).data "filter-contacts"
  false

$("a[data-view]").click (e) ->
  view = $(this).data('view')
  $(".view_buttons").each () ->
    $(this).removeClass("active")
  $(".view_buttons##{view}").addClass("active")
  $(".contacts").each () ->
    $(this).hide()
  $(".contacts##{view}").show()
  $.cookie "contacts_view", view
  false

$("a[data-call]").click (e) ->
  clearTimeout window.timeout_id
  $.getJSON "/make_call/#{$(this).data('call')}.json", (data, status, xhr) ->
    $('#modal_alert .alert-box').text data['message']
    window.timeout_id = setTimeout(() ->
      $('#modal_alert').foundation('reveal', 'close')
    ,5000)
    $('#modal_alert').foundation('reveal', 'open')
  $('#modal_alert .alert-box').text "Пожалуйста, снимите трубку!"
  $('#modal_alert').foundation 'reveal', 'open'
  false

$("a[data-open-popup]").click (e) ->
  $.getJSON "/contacts/edit/#{$(this).data('open-popup')}.json", (data, status, xhr) ->
    $("#contact_edit_popup").html data["html"]
  $("#contact_edit_popup").foundation('reveal', 'open')
  false

$("input[data-update-upload]").on "change", () ->
  console.log $("##{$(this).data 'update-upload'}")
  console.log $("##{$(this).data 'update-upload'}").html()

#$('#contacts_filter').focus()
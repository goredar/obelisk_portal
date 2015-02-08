# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

filter_contacts = (pattern) ->
  $('#contacts_filter').val pattern
  $.cookie "saved_search_string", pattern
  $('#contacts .contact').each ->
    if $(this).data('filter').toLowerCase().indexOf(pattern.toLowerCase()) == -1
      $(this).hide()
    else
      $(this).show()
  $('#contacts_filter').focus()

$('#contacts_filter').bind 'input', ->
  filter_contacts $(this).val()

$('#clear_contacts_filter').bind 'click', ->
  filter_contacts ""

filter_contacts $.cookie "saved_search_string"
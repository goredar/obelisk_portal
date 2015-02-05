# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('#contacts_filter').bind 'input', ->
  pattern = $(this).val()
  $('#contacts .contact').each ->
    if $(this).data('filter').toLowerCase().indexOf(pattern.toLowerCase()) == -1
      $(this).hide()
    else
      $(this).show()
$('#contacts_filter').focus()
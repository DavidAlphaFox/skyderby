class Skyderby.views.NewTrackForm extends Backbone.View
  events:
    'click .toggle-suit'              : 'on_toggle_suit_mode'

  initialize: ->
    @init_form_validation()
    # modal is hidden when view init so we need to check css display property
    select_hidden = @$('.new-track-suit-select').css('display') == 'none'
    # if select hidden - then we need to hide select2 control after
    # instantiation and change text in link
    if select_hidden
      @$('.new-track-suit-select + span').hide()
      @set_toggle_link_text(I18n.t('tracks.form.toggle_suit_link_select'))
      @set_toggle_caption(I18n.t('tracks.form.toggle_suit_caption_select'))

    $(document).one 'turbolinks:before-cache', ->
      $('#newTrackModal').modal('hide')

  init_form_validation: ->
    @$('#track_upload_form').validate(
      ignore: 'input[type=hidden]',
      rules:
        'track_file[track_attributes][name]':
          minlength: 3,
          required: ->
            return $('#newTrackModal input#name')
        'track_file[track_attributes][suit_id]':
          required: ->
            $('[name="track_file[track_attributes][suit_id]"]').is(':visible')
        'track_file[track_attributes][missing_suit_name]':
          required: ->
            $('[name="track_file[track_attributes][missing_suit_name]"]').is(':visible')
        'track_file[track_attributes][location]':
          minlength: 3,
          required: true
        'track_file[file]':
          required: true,
          extension: 'csv|gpx|tes|kml',
          filesize: 3145728 # 3 Mb
      messages:
        'track_file[file]':
          extension: 'Please enter file with valid extension (csv, gpx, tes, kml)',
          filesize: 'File should be less than 3MB'
        'track_file[track_attributes][suit]':
          require_from_group: 'This field is required.'
      highlight: (element) ->
        $(element).closest('.form-group').addClass('has-error')
      unhighlight: (element) ->
        $(element).closest('.form-group').removeClass('has-error')
      errorPlacement: (error, element) ->
        if (element.attr("name") == "track_file[file]")
          error.appendTo( element.closest(".col-sm-9") )
        else if(element.hasClass('suit-group'))
          error.appendTo( element.closest('div') )
        else
          error.insertAfter(element)
    )

  on_toggle_suit_mode: (e) ->
    e.preventDefault()

    if @current_suit_mode() == 'enter'
      link_text = I18n.t('tracks.form.toggle_suit_link')
      toggle_caption = I18n.t('tracks.form.toggle_suit_caption')
      @clean_hide_suit_input()
      @show_suit_select()
    else
      link_text = I18n.t('tracks.form.toggle_suit_link_select')
      toggle_caption = I18n.t('tracks.form.toggle_suit_caption_select')
      @clean_hide_suit_select()
      @show_suit_input()

    @set_toggle_link_text(link_text)
    @set_toggle_caption(toggle_caption)

  set_toggle_link_text: (el_text) ->
    @$('.toggle-suit').text(el_text)

  set_toggle_caption: (el_text) ->
    @$('.toggle-suit-caption').text(el_text)

  clean_hide_suit_input: ->
    @$('input[name="track_file[track_attributes][missing_suit_name]"]').val('').hide()

  clean_hide_suit_select: ->
    @$('.new-track-suit-select').val(null).trigger('change')
    @$('.new-track-suit-select').hide()
    @$('.new-track-suit-select + span').hide()

  show_suit_input: ->
    @$('input[name="track_file[track_attributes][missing_suit_name]"]').show()

  show_suit_select: ->
    @$('.new-track-suit-select').show()
    @$('.new-track-suit-select + span').show()

  current_suit_mode: ->
    if @$('[name="track_file[track_attributes][missing_suit_name]"]').is(':visible') then 'enter' else 'select'

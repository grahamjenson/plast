class Plast.Views.HelpContainer extends Backbone.View

  template: JST['header/help_container']

  events:
    'click #js-help-btn' : 'hideHelp'
    'click #js-help-icon' : 'showHelp'
    'click #search' : 'hideHelp'


  initialize: ->
    $(@el).find('#js-help-container').html(@template())
    this


  hideHelp: (e) ->
    if $('#js-help-container').is(":visible")
      $('#js-help-container').animate({
          height: 'toggle'
        }, 1000, ->
          $('.nav.nav-tabs').animate({ width: 'toggle' }, 1000)
      )

  showHelp: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('.nav.nav-tabs').animate({
        width: 'toggle'
      }, 1000, ->
        $('#js-help-container').animate({ height: 'toggle' }, 1000)
    )

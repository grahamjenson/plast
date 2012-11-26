class Plast.Views.HelpContainer extends Backbone.View

  template: JST['header/help_container']

  events:
    'click #js-close-help' : 'toggleHelp'



  initialize: ->
    $('#js-help-container-wrapper').html(@template())
    this
    @time_to_close = 500


  toggleHelp: (e) ->
    $('#js-help-container').animate({ height: 'toggle' }, @time_to_close)
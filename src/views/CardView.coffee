class window.CardView extends Backbone.View
  className: 'card'

  template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: -> @render()

  render: ->
    console.log @model.get 'value'
    @$el.children().detach()
    @$el.html @template @model.attributes
    @$el.addClass 'covered' unless @model.get 'revealed'


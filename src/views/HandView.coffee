class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'add remove change', => @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    if @collection.hasAce()
      @$('.score').text "#{@collection.scores()[0]}, #{@collection.scores()[1]}"
    else
      @$('.score').text @collection.scores()[0]
    if @collection.scores()[0] > 21
      alert 'Player busts!'


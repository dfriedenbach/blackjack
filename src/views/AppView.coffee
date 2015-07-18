class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button> <button class="deal-button">Deal</button>
    <p class="message-box"><%= message %></p>
    <p class="current-money">Current money: $<%= money %></p>
    <p class="current-bet">Current bet: $<%= bet %></p>
    <span class="make-bet">Make a bet: </span><input class="make-bet" name="make-bet" type="number" value="5" min="5" max="50" step="1" />
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()
    'click .deal-button': -> @model.deal()

  initialize: ->
    @render()

    @model.on 'reset', ->
      @render()
    , @

    # @model.on 'dealer-win', ->
    #   $('.message-box').text('Dealer wins').fadeTo(1000, 1)
    # , @

  render: ->
    @$el.children().detach()
    @$el.html @template(@model.attributes)
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el


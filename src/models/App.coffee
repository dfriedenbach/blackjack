# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @playerEventListeners()

  playerEventListeners: ->
    @get 'playerHand'
    .on 'stand', ->
      @get 'dealerHand'
      .dealerTurn()
      dealerScore = @get('dealerHand').bestScore()
      playerScore = @get('playerHand').bestScore()
      if dealerScore > playerScore and dealerScore <= 21
        alert 'Dealer wins'
      else if dealerScore == playerScore
        alert 'Push'
      else
        alert 'Player wins'
      @reset()
    , @

    @get 'playerHand'
    .on 'gameover', ->
      @reset()
    , @

  reset: ->
    @set 'playerHand', @get('deck').dealPlayer()
    @set 'dealerHand', @get('deck').dealDealer()
    @playerEventListeners()
    @trigger 'reset'

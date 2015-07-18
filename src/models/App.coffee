# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'message', ''
    @set 'playerHand', new Hand [], deck
    @set 'dealerHand', new Hand [], deck, true
    @set 'money', 200
    @set 'bet', 0
    @set 'lastBet', 5

  playerEventListeners: ->
    @get 'playerHand'
    .on 'stand', ->
      @get 'dealerHand'
      .dealerTurn()
      dealerScore = @get('dealerHand').bestScore()
      playerScore = @get('playerHand').bestScore()
      if dealerScore > 21
        @set 'message', 'Dealer bust, Player wins'
        @set('money', @get('money') + @get('bet'))
      else if dealerScore > playerScore
        @set 'message', 'Dealer wins'
        @set('money', @get('money') - @get('bet'))
      else if dealerScore == playerScore
        @set 'message', 'Push'
      else
        @set 'message', 'Player wins'
        @set('money', @get('money') + @get('bet'))
      @reset()
    , @

    @get 'playerHand'
    .on 'player-bust', ->
      @set 'message', 'Player bust'
      @set('money', @get('money') - @get('bet'))
      @reset()
    , @

    @get 'playerHand'
    .on 'double', ->
      @set('bet', @get('bet') * 2)
    , @

    @get 'playerHand'
    .on 'hit', ->
      @trigger 'hit'
    , @

  deal: (bet) ->
    if bet < 5 or bet > 50
      alert 'All bets must be between $5 and $50'
    else if @get('money') - bet < 0
      alert 'You don\'t have that much money'
    else
      @set 'bet', bet
      @set 'lastBet', bet
      @set 'playerHand', @get('deck').dealPlayer()
      @set 'dealerHand', @get('deck').dealDealer()
      @playerEventListeners()
      @set 'message', ''
      @trigger 'reset'
      dealerScore = @get('dealerHand').dealerBestScore()
      playerScore = @get('playerHand').bestScore()
      if playerScore == 21
        if dealerScore == 21
          @get('dealerHand').at(0).flip()
          @set 'message', 'Push'
        else
          @set 'message', 'Blackjack!'
          @set('money', @get('money') + @get('bet') * 1.5)
        @reset()
      else if dealerScore == 21
        @get('dealerHand').at(0).flip()
        @set 'message', 'Dealer Blackjack!'
        @set('money', @get('money') - @get('bet'))
        @reset()
      else
        @trigger 'playing'

  reset: ->
    if @get('deck').length <= 13
      @set 'deck', deck = new Deck()
    else
      deck = @get 'deck'
    @set 'bet', 0
    @trigger 'reset'
    @trigger 'game-over'

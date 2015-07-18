# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', new Hand [], deck
    @set 'dealerHand', new Hand [], deck, true
    @set 'money', 200
    @set 'bet', 0

  playerEventListeners: ->
    @get 'playerHand'
    .on 'stand', ->
      @get 'dealerHand'
      .dealerTurn()
      dealerScore = @get('dealerHand').bestScore()
      playerScore = @get('playerHand').bestScore()
      if dealerScore > playerScore and dealerScore <= 21
        alert 'Dealer wins'
        @set('money', @get('money') - @get('bet'))
      else if dealerScore == playerScore
        alert 'Push'
      else
        alert 'Player wins'
        @set('money', @get('money') + @get('bet'))
      @reset()
    , @

    @get 'playerHand'
    .on 'gameover', ->
      @set('money', @get('money') - @get('bet'))
      @reset()
    , @

  deal: ->
    bet = +$('.make-bet')[1].value
    if bet < 5 or bet > 50
      alert 'All bets must be between $5 and $50'
    else if @get('money') - bet < 0
      alert 'You don\'t have that much money'
    else
      @set 'bet', bet
      @set 'playerHand', @get('deck').dealPlayer()
      @set 'dealerHand', @get('deck').dealDealer()
      @playerEventListeners()
      @trigger 'reset'
      dealerScore = @get('dealerHand').dealerBestScore()
      playerScore = @get('playerHand').bestScore()
      if playerScore == 21
        if dealerScore == 21
          @get('dealerHand').at(0).flip()
          alert 'Push'
        else
          alert 'Blackjack!'
          @set('money', @get('money') + @get('bet') * 1.5)
        @reset()
      else if dealerScore == 21
        @get('dealerHand').at(0).flip()
        alert 'Dealer Blackjack!'
        @set('money', @get('money') - @get('bet'))
        @reset()

  reset: ->
    if @get('deck').length <= 13
      @set 'deck', deck = new Deck()
    else
      deck = @get 'deck'
    # @set 'playerHand', new Hand [], deck
    # @set 'dealerHand', new Hand [], deck, true
    @set 'bet', 0
    @trigger 'reset'

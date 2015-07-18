assert = chai.assert

describe 'app', ->
  app = null

  beforeEach ->
    app = new App()
    app.get 'deck'
    .add [7,6,10,10,5,5,5,5].map (card) ->
      new Card
        rank: card % 13
        suit: Math.floor(card / 13)

  it "should say 'Player bust' when the player exceeds 21 points", ->
    app.deal(5)
    app.get('playerHand').hit()
    assert.strictEqual app.get('message'), ''
    app.get('playerHand').hit()
    assert.strictEqual app.get('message'), 'Player bust'

  it "should say 'Dealer bust, Player wins' when the dealer exceeds 21 points", ->
    app.deal(5)
    app.get('deck').pop()
    app.get('deck').pop()
    assert.strictEqual app.get('message'), ''
    app.get('playerHand').stand()
    assert.strictEqual app.get('message'), 'Dealer bust, Player wins'

  it "should say 'Dealer wins' when no one busts and the dealer has more points", ->
    app.deal(5)
    assert.strictEqual app.get('message'), ''
    app.get('playerHand').stand()
    assert.strictEqual app.get('message'), 'Dealer wins'

  it "should say 'Push' when no one busts and both scores are equal", ->
    app.deal(5)
    app.get('playerHand').hit()
    assert.strictEqual app.get('message'), ''
    app.get('playerHand').stand()
    assert.strictEqual app.get('message'), 'Push'

  it "should say 'Player wins' when no one busts and the player has more points", ->
    app.deal(5)
    app.get('playerHand').hit()
    assert.strictEqual app.get('message'), ''
    app.get('deck').pop()
    app.get('deck').pop()
    app.get('playerHand').stand()
    assert.strictEqual app.get('message'), 'Player wins'

  it "should say 'Blackjack!' when only the player is dealt a Blackjack", ->
    app.get 'deck'
    .add [1,11].map (card) ->
      new Card
        rank: card % 13
        suit: Math.floor(card / 13)
    assert.strictEqual app.get('message'), ''
    app.deal(5)
    assert.strictEqual app.get('message'), 'Blackjack!'

  it "should say 'Dealer Blackjack!' when only the dealer is dealt a Blackjack", ->
    app.get 'deck'
    .add [1,11,5,5].map (card) ->
      new Card
        rank: card % 13
        suit: Math.floor(card / 13)
    assert.strictEqual app.get('message'), ''
    app.deal(5)
    assert.strictEqual app.get('message'), 'Dealer Blackjack!'

  it "should say 'Push' when both the player and the dealer are dealt a Blackjack", ->
    app.get 'deck'
    .add [1,11,1,11].map (card) ->
      new Card
        rank: card % 13
        suit: Math.floor(card / 13)
    assert.strictEqual app.get('message'), ''
    app.deal(5)
    assert.strictEqual app.get('message'), 'Push'
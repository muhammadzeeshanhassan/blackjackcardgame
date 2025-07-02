class Card 
    attr_reader :value, :suit;
    def initialize(value, suit) 
        @value = value;
        @suit = suit
    end

    def to_s
        "#{value}#{suit}"
    end
end

# card = Card.new("A", "♠")
# puts card        
# puts card.value   
# puts card.suit    

class Deck
    attr_reader :cards;
    def initialize()
        @cards = []
        build_deck()
        shuffle!
    end

    def build_deck()
        suits = ['♠', '♥', '♦', '♣']
        values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

        suits.each { |s|
            values.each { |v|
                @cards << Card.new(v,s)
            }
        }
        # puts @cards;
    end

    def shuffle!
        @cards.shuffle!
        # puts @cards;
    end

    def deal
        @cards.pop
    end
    
end

# deck = Deck.new
# card = deck.deal
# # card = deck.deal
# # card = deck.deal
# puts card         
# puts deck.cards.size

class Hand
  attr_reader :cards

  def initialize()
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def show_cards(hidden = false)
    if hidden
      result = "[Hidden]"
      for i in 1...@cards.length
        result += ", " + @cards[i].to_s
      end
      return result
    else
      result = ""
      for card in @cards
        result += card.to_s + ", "
      end
       return result
    end
  end

  def total()
    sum = 0
    aces = 0

    @cards.each do |card|
      case card.value
      when "A"
        sum += 11
        aces += 1
      when "K", "Q", "J"
        sum += 10
      else
        sum += card.value.to_i
      end
    end

    while sum > 21 && aces > 0
      sum -= 10
      aces -= 1
    end

    sum
  end

  def busted?()
    total > 21
  end
end

# hand = Hand.new
# hand.add_card(Card.new("A", "♠"))
# hand.add_card(Card.new("9", "♥"))
# puts hand.show_cards      
# puts hand.total          
# puts hand.busted?  

class Participant
    attr_reader :hand, :name;
    def initialize(name)
        @name = name;
        @hand = Hand.new
    end

    def add_card(card)
        @hand.add_card(card)
    end

    def show_hand(hidden = false)
        puts "#{name}'s cards: #{hand.show_cards(hidden)}"
        puts "#{name}'s total: #{hand.total}" unless hidden
    end

    def busted?()
        hand.busted?
    end

    def total()
        hand.total
    end
end


class Player < Participant
  def initialize
    super('Player') 
  end
end

class Dealer < Participant
  def initialize
    super('Dealer')  
  end

  # Dealer hits until total >= 17
  def play(deck)
    while total < 17
      puts "Dealer hits..."
      add_card(deck.deal)
      sleep(1)  
      show_hand(true)  
    end
    puts "Dealer stands." if total >= 17
  end
end


# deck = Deck.new
# player = Player.new
# dealer = Dealer.new

# player.add_card(deck.deal)
# player.add_card(deck.deal)

# dealer.add_card(deck.deal)
# dealer.add_card(deck.deal)

# player.show_hand
# dealer.show_hand(true)


class Game
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    puts "🎮 Welcome to Blackjack!"
    deal_initial_cards
    show_initial_hands
    player_turn
    dealer_turn unless @player.busted?
    show_result
  end

  private


  def deal_initial_cards
    2.times do
      @player.add_card(@deck.deal)
      @dealer.add_card(@deck.deal)
    end
  end

  # Show hands (dealer hides first card)
  def show_initial_hands
    @player.show_hand
    @dealer.show_hand(true)  # Dealer hides first card
  end

  def player_turn
    while !@player.busted?
      puts "\nDo you want to Hit or Stand? (h/s)"
      choice = gets.chomp.downcase

      if choice == 'h'
        @player.add_card(@deck.deal)
        @player.show_hand
      elsif choice == 's'
        puts "You chose to stand."
        break
      else
        puts "Invalid choice. Please enter 'h' or 's'."
      end
    end

    puts "You busted!" if @player.busted?
  end

  def dealer_turn
    puts "\nDealer's turn..."
    sleep(1)
    @dealer.show_hand  

    @dealer.play(@deck)

    puts "Dealer busted!" if @dealer.busted?
  end

  def show_result
    puts "\nFinal Hands:"
    @player.show_hand
    @dealer.show_hand

    if @player.busted?
      puts "You busted. Dealer wins!"
    elsif @dealer.busted?
      puts "Dealer busted. You win!"
    elsif @player.total > @dealer.total
      puts "You win!"
    elsif @player.total < @dealer.total
      puts "Dealer wins!"
    else
      puts "It's a draw!"
    end
  end
end

game = Game.new
game.start()
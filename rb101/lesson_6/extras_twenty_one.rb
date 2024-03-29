SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
WINNING_TOTAL = 31
DEALER_STOP = 27

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0 # J, Q, K
             10
           else
             value.to_i
           end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 31
  end

  sum
end

def busted?(player_total)
  player_total > 31
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_total, player_total)
  if player_total > 31
    :player_busted
  elsif dealer_total > 31
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_total, player_total, score)
  result = detect_result(dealer_total, player_total)

  case result
  when :player_busted
    score['Dealer'] += 1
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    score['Player'] += 1
    prompt "Dealer busted! You win!"
  when :player
    score['Player'] += 1
    prompt "You win!"
  when :dealer
    score['Dealer'] += 1
    prompt "Dealer wins!"
  when :tie
    score['Ties'] += 1
    prompt "It's a tie!"
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def grand_output(dealer_cards, player_cards, dealer_total, player_total, score)
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Player has #{player_cards}, for a total of: #{player_total}"
  puts "=============="

  display_result(dealer_total, player_total, score)
  puts "The current score:" +
       "\nPlayer: #{score['Player']}" +
       "\nDealer: #{score['Dealer']}" +
       "\nTies: #{score['Ties']}"
end

score = {"Player" => 0, "Dealer" => 0, "Ties" => 0 }

loop do
  prompt "Welcome to Twenty-One!"

  # initialize vars
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  player_total = total(player_cards)
  dealer_total = total(dealer_cards)
  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{player_cards[0]} and #{player_cards[1]}, for a total of #{player_total}."

  # player turn
  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Sorry, must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      player_total = total(player_cards)
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      prompt "Your total is now: #{player_total}"
    end

    break if player_turn == 's' || busted?(player_total)
  end

  if busted?(player_total)
    grand_output(dealer_cards, player_cards, dealer_total, player_total, score)
    break if score['Dealer'] == 5
    play_again? ? next : break
  else
    prompt "You stayed at #{player_total}"
  end

  # dealer turn
  prompt "Dealer turn..."

  loop do
    break if dealer_total >= 27

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    dealer_total = total(dealer_cards)
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  if busted?(dealer_total)
    grand_output(dealer_cards, player_cards, dealer_total, player_total, score)
    break if score['Player'] == 5
    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_total}"
  end

  # both player and dealer stays - compare cards!
  grand_output(dealer_cards, player_cards, dealer_total, player_total, score)
  break if score['Player'] == 5 || score['Dealer'] == 5
  break unless play_again?
end

puts "-------------"
puts "The final score:" +
     "\nPlayer: #{score['Player']}" +
     "\nDealer: #{score['Dealer']}" +
     "\nTies: #{score['Ties']}"
prompt "And the grand champion is ... " + "#{score.key(5)}!"
prompt "Thank you for playing Twenty-One! Good bye!"

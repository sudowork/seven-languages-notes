def getRandAnswer(max = 10)
  rand(max) + 1
end

STDOUT.sync

puts "Welcome to the random number game!"
puts "\tTo quit, answer 'q' at any time"

guess = nil
max = 10
answer = getRandAnswer(10)

while true
  puts "Guess a number from 1 to #{max}:"
  guess = gets.chomp
  break if guess == 'q'

  gNum = guess.to_i
  if gNum == answer
    puts "Correct!"
    answer = getRandAnswer(10)
  elsif gNum < answer
    puts "Too low"
  else
    puts "Too high"
  end
end

## Ruby

### Day 1. Finding a Nanny

* Functions covered: `puts`
* Methods covered: `.class`, `to_i`, `to_a`, `to_s`
* [Full table of operators](http://www.techotopia.com/index.php/Ruby_Operator_Precedence#Operator_Precedence_Table)
* Comparison operators (order of precedence):
  * `( )`   Note: not really an operator, but oh well
  * `<=`, `<`, `>`, `>=`
  * `<=>`, `==`, `===`, `!=`, `=~`, `!~`
* Logical Operators
  * `&&`
  * `||`
  * `not`
  * `or`, `and`
* Expression modifiers
  * `if`, `unless`, `while`, `until`
* Tricky precedence nuance
  * Don't use `or`, `and`, or `not` when dealing with assignment, and don't mix `&&` and `||` with `and` and `or`.

    ```ruby
    >> foo = false or true    # This expression evaluates to true
    => true
    >> foo                    # But it assigned foo to false
    => false
    ```
  * Why? `and`, `or`, and `not` are lower precedence than assignment.
  * So when is it okay to use them?

    ```ruby
    ```
* Ruby is ...
  * **Interpreted**: No compilation necessary
  * **Object-oriented**: Everything is an object
  * **Strongly typed**: Types must be compatible or _coercible_
  * **Dynamically typed**: Type checking is performed at run-time
  * **Duck typed**: If it looks like a duck and quacks like a duck, it must be a duck. In other words, if an object has a particular method, it doesn't matter what type it is

### Day 1. Self-Study
* Find
  * [The Ruby API](http://www.ruby-doc.org)
  * The free online version of _Programming Ruby: The Pragmatic Programmer's Guide_ [(link)](http://www.ruby-doc.org/docs/ProgrammingRuby/)
  * A method that substitutes part of a string

      ```ruby
      >> foo = 'The quick brown fox jumps over the lazy dog.'
      >> foo['The'] = 'A'             # Replace first occurrence of "The" in string foo
      >> foo.sub('quick', 'fast')     # Returns copy of foo with "quick" replaced with "fast"
      >> foo.sub!(/quick/, 'speedy')  # Replaces substring "quick" with "speedy" in place (we use a regex pattern just for the sake of demonstration)
      >> foo.gsub!(/a/i, 'the')       # Case-insensitive, replace all occurrences of "a" with "the" in-place
      ```

  * [Ruby's regular expressions](http://www.ruby-doc.org/core-1.9.3/Regexp.html)
  * [Ruby's ranges](http://www.ruby-doc.org/core-1.9.3/Range.html)
* Do

    ```ruby
    # Print the string "Hello, World"
    puts "Hello, world."

    # For the string “Hello, Ruby,” find the index of the word “Ruby.”
    'Hello, Ruby' =~ /Ruby/
    'Hello, Ruby'.index('Ruby')

    # Print your name 10 times
    puts "Kevin Gao\n" * 10

    # Print the string "This is sentence number 1," where the number 1 changes from 1 to 10.
    (1..10).each do |num|
      puts "This is sentence number #{num}"
    end
    ```
  * Run a Ruby program from a file: `ruby 01-randnumgame.rb`
  * Bonus problem: Write a program that picks a random number. Let a player guess the number, telling the player whether the guess is too low or too high.

    ```ruby
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
    ```

# Ruby Self-Study

## Day 1. Self-Study

### Find

  * [The Ruby API][Ruby API]
  * The free online version of [_Programming Ruby: The Pragmatic Programmer's Guide_][Programming Ruby]
  * [A method][gsub] that substitutes part of a string

      ```ruby
      >> foo = 'The quick brown fox jumps over the lazy dog.'
      >> foo['The'] = 'A'             # Replace first occurrence of "The" in string foo
      >> foo.sub('quick', 'fast')     # Returns copy of foo with "quick" replaced with "fast"
      >> foo.sub!(/quick/, 'speedy')  # Replaces substring "quick" with "speedy" in place (we use a regex pattern just for the sake of demonstration)
      >> foo.gsub!(/a/i, 'the')       # Case-insensitive, replace all occurrences of "a" with "the" in-place
      ```

  * [Ruby's regular expressions][Regex]
  * [Ruby's ranges][Range]

### Do

Print the string "Hello, World"
```ruby
puts "Hello, world."
```

For the string “Hello, Ruby,” find the index of the word “Ruby.”
```ruby
'Hello, Ruby' =~ /Ruby/     # Using regular expression matching
'Hello, Ruby'.index('Ruby') # Using the index method
```

Print your name 10 times
```ruby
puts "Kevin Gao\n" * 10
10.times { puts "Yang Su" }
```

Print the string "This is sentence number 1," where the number 1 changes from 1 to 10.
```ruby
(1..10).each do |num|                     # Using a range
  puts "This is sentence number #{num}"
end

1.upto(10) do |num|                       # Using an enumerator
  puts "This is sentence number #{num}"
end
```

Run a Ruby program from a file
```bash
ruby 01-randnumgame.rb
```

Bonus problem: write a program that picks a random number. Let a player guess the number, telling the player whether the guess is too low or too high.

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

## Day-2: Self-Study
### Find

* Find out how to access files with and without code blocks. What is the benefit of the code block?

    ```ruby
    # With code blocks
    File.open('foo.bar', 'w') { |f| f << 'bazzbuzz' }

    # Without code blocks
    file = File.open('foo.bar', 'w')
    file << 'bazzbuzz'
    file.close
    ```
  The benefit of using a code block is that it wraps resource handling policies around the block, rather than the coder using the API having to deal with it. Also, it's just pretty.

* How would you translate a hash to an array? `Hash.values`. Can you translate arrays to hashes? `Hash[*array]`.

* Can you iterate through a hash? _Yes_.
    ```ruby
    {:array=>[1, 2, 3], :string=>"Hello"}.each {|k, v| puts "k: #{k}, v: #{v}"}
    # => k: array, v: [1, 2, 3]
    # => k: string, v: Hello
    ```

* You can use Ruby arrays as stacks. What other common data structures do arrays support? _Queues_, _Sets_

### Do

Print the contents of an array of sixteen numbers, four numbers at a time, using just each. Now, do the same with each_slice in Enumerable.
```ruby
a = (1..16).to_a
b = []
a.each do |x|
  b.push x
  if b.length == 4
    puts b.join(',')
    b.clear
  end
end

a = (1..16).to_a
a.each_slice(4) { |xs| puts xs.join(',') }
```

The Tree class was interesting, but it did not allow you to specify a new tree with a clean user interface. Let the initializer accept a nested structure with hashes and arrays. You should be able to specify a tree like this: `{’grandpa’ => { ’dad’ => {’child 1’ => {}, ’child 2’ => {} }, ’uncle’ => {’child 3’ => {}, ’child 4’ => {} } } }`.

```ruby
class Tree
  attr_accessor :children, :node_name
  def initialize(tree)
    @children = []
    if tree.size == 1
      @node_name = tree.keys[0]
      tree[@node_name].each do |child, grandchildren|
        @children << Tree.new({ child => grandchildren })
      end
    end
  end
  def visit_all(&block)
    visit &block  # pre-order
    children.each {|c| c.visit_all &block}  # recursive, pre-order dfs
  end
  def visit(&block)
    block.call self
  end
  def to_s
    @node_name
  end
end
tree = Tree.new({ # Note Hashes in Ruby < 1.9 are unlinked; Hashes in Ruby >= 1.9 are linked
  'root' => {
    'child_a' => {},
    'child_b' => {},
    'child_c' => {
      'child_d' => {
        'child_e' => {}
      }
    },
    'child_f' => {}
  }
})

puts "visit single node"
tree.visit {|node| puts node.node_name}
# root

puts "visit tree"
tree.visit_all {|node| puts node.node_name}
# root
# child_a
# child_b
# child_c
# child_d
# child_e
# child_f
```

Write a simple grep that will print the lines of a file having any occurrences of a phrase anywhere in that line. You will need to do a simple regular expression match and read lines from a file. (This is surprisingly simple in Ruby.) If you want, include line numbers.
```ruby
def grep(filename, phrase)
  File.open(filename, 'r').each_with_index do |line, lineNumber|
    puts "#{lineNumber}: #{line}" if line =~ /#{phrase}/
  end
end
```

## Day 3: Self-Study

Modify the CSV application to support an each method to return a CsvRow object. Use `method_missing` on that CsvRow to return the value for the column for a given heading.

Alternative 1 using method_missing on Hash
```ruby
class Hash
  def method_missing name, *args
    self[name.to_s]
  end
end

module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each
      @csv_contents.each do |row|
        yield Hash[@headers.zip row]
      end
    end

    attr_accessor :headers, :csv_contents
    def initialize
      read
    end
  end
end

class RubyCsv  # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csv
end

csv = RubyCsv.new
csv.each { |row| puts row.one }  # test new each method
```

Alternative 2 using a class and Procs
```ruby
class Row
  def initialize(row)
    row.each do |k,v|
      # Ruby's reflection, invokes a method with arguments
      self.class.send(:define_method, k.to_sym, lambda { v })
    end
  end
end

module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each
      @csv_contents.each do |row|
        yield Row.new(Hash[@headers.zip row])
      end
    end

    attr_accessor :headers, :csv_contents
    def initialize
      read
    end
  end
end

class RubyCsv  # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csv
end

csv = RubyCsv.new
csv.each { |row| puts row.one }  # test new each method
```

<!-- links -->
[Programming Ruby]: http://www.ruby-doc.org/docs/ProgrammingRuby/
[Range]: http://www.ruby-doc.org/core-1.9.3/Range.html
[Regex]: http://www.ruby-doc.org/core-1.9.3/Regexp.html
[Ruby API]: http://www.ruby-doc.org
[gsub]: http://www.ruby-doc.org/core-1.9.3/String.html#gsub-method

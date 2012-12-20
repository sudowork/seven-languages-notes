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

### Day 2: Floating Down from the Sky
* Defining functions

    ```ruby
    def say_hello(name = "World")
      puts "Hello, #{name}!"
    end
    ```

* Arrays
  * Literal form: `animals = ['lions', 'tigers', 'bears']`
  * Accessing: `animals[0] # "lions"`
  * Accessing out of bounds: `animals[10] # nil`
  * Accessing using negative index: `animals[-1] # "bears"`
  * Accessing with range: `animals[1..2] # ["tigers", "bears"]`
  * Ranges: `(0..1).class # Range`
  * Arrays can hold mixed types (non-homogenous); the following is valid: `[1, 'two', 3, '4']`
  * `[]` and `[]=` are just methods of the Array class; their typical usage is just syntactic sugar
  * Multidimensional arrays are just arrays of arrays
  * `push` and `pop` exist natively in the [Array API](http://www.ruby-doc.org/core-1.9.3/Array.html)

* Hashes (Maps)
  * `numbers = { 1 => 'one', 2 => 'two' }`
  * `numbers[1] # "one"`
  * Can use symbols as keys: `stuff = { :array => [1, 2, 3], :string => 'Hello' }`
  * `stuff[:string] # "Hello"`
  * **symbol**s are identifying values/objects. Two symbols of the same name always refer to the same object id
  * Named parameters can be implemented using a Hash

* Code blocks and yielding
  * `{ ... }` code between braces is a code block; alternavitely, `do ... end` (usually for multi-line blocks) syntax can be used
  * `Fixnum.times` can be used to loop a certain number of times: `3.times { puts 'Hello, World!' }`
  * Use `each` on a collection (Array or Hash) to iterate over the elements in the collection: `animals.each { |a| puts a }` and `numbers.each { |k,v| puts "#{k} maps to #{v}" }`
  * Augmenting a class definition and using **yield** to call a block

    ```ruby
    class Fixnum
      def my_times
        i = self
        while i > 0
          i -= 1
          yield
        end
      end
    end
    ```

  * Alternatively, call a block using `call`

    ```ruby
    def call_block(&block)
      block.call 1, 2
    end
    call_block { |a,b| puts "Hello #{a} and #{b}" } # "Hello 1 and 2"

    def yield_params
      yield 1, 2
    end
    yield_params { |a,b| puts "#{a} and #{b}" } # "1 and 2"
    ```
  * Useful for policy enforcement, conditional execution, transactions, etc.

* Tree implementation

    ```ruby
    class Tree
      attr_accessor :children, :node_name

      def initialize(name, children=[])
        @children = children
        @node_name = name
      end

      def visit_all(&block)
        visit &block
        children.each {|c| c.visit_all &block}
      end

      def visit(&block)
        block.call self
      end
    end

    tree = Tree.new("root", [
    Tree.new('child_a'),
    Tree.new('child_b'),
    Tree.new('child_c', [
      Tree.new('child_d', [
        Tree.new('child_e')
      ]),
      Tree.new('child_f')
    ])

    puts "visit single node"
    tree.visit {|node| puts node.node_name}

    puts "visit tree"
    tree.visit_all {|node| puts node.node_name}
    ```

  * Mixins and Modules

    ```ruby
    module ToFile
    def filename
      "object_#{self.object_id}.txt"
    end
    def to_f
      File.open(filename, 'w') {|f| f.write(to_s)}
    end end

    class Person
      include ToFile
      attr_accessor :name

      def initialize(name)
        @name = name
      end
      def to_s
        name
      end
    end

    Person.new('Kevin').to_f
    ```
  * **enumerable** and **comparable** are important modules/mixins.
  * A **comparable** class must implement **<=>** (spaceship) operator
  * [**enumerable**](http://ruby-doc.org/core-1.9.3/Enumerable.html) include the following methods: `sort`, `any?`, `all?`, `collect` (map), `map`, `flat_map`, `select` (filter), `find`, `max`, `min`, `member?`, `inject` (reduce), `reduce`

### Day-2: Self-Study
* Find
  * Find out how to access files with and without code blocks. What is the benefit of the code block?

    ```ruby
    # With code blocks
    File.open('foo.bar', 'w') { |f| f << 'bazzbuzz' }
    # Without code blocks
    file = File.open('foo.bar', 'w')
    file << 'bazzbuzz'
    file.close
    # The benefit of using a code block is that it wraps resource handling policies around the block,
    # rather than the coder using the API having to deal with it. Also, it's just pretty.
    ```
  * How would you translate a hash to an array? `Hash.values`. Can you translate arrays to hashes? `Hash[*array]`.
  * Can you iterate through a hash? _Yes_.
  * You can use Ruby arrays as stacks. What other common data structures do arrays support? _Queues_.
* Do

    ```ruby
    # Print the contents of an array of sixteen numbers, four numbers at a time, using just each. Now, do the same with each_slice in Enumerable.
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

    # The Tree class was interesting, but it did not allow you to specify a new tree with a clean user interface. Let the initializer accept a nested structure with hashes and arrays. You should be able to specify a tree like this: {’grandpa’ => { ’dad’ => {’child 1’ => {}, ’child 2’ => {} }, ’uncle’ => {’child 3’ => {}, ’child 4’ => {} } } }.
    class Tree
      attr_accessor :children, :node_name
      def initialize(tree)
        @children = []
        if tree.size == 1
          @node_name = tree.keys[0]
          tree[@node_name].each do |child, grandchildren|
            @children << Tree.new({ child => grandchildren })
          end
        else
          @node_name = nil
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
    puts "visit tree"
    tree.visit_all {|node| puts node.node_name}

    # Write a simple grep that will print the lines of a file having any occurrences of a phrase anywhere in that line. You will need to do a simple regular expression match and read lines from a file. (This is surprisingly simple in Ruby.) If you want, include line numbers.
    def grep(filename, phrase)
      File.open(filename, 'r').each do |line|
        puts line if line =~ /#{phrase}/
      end
    end
    ```

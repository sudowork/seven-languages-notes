# Ruby

## Day 1. Finding a Nanny

* Functions covered: `puts`
* Methods covered: `.class`, `to_i`, `to_a`, `to_s`
* [Full table of operators][operators]
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
    * Why? `and`, `or`, and `not` are lower precedence than assignment.
    * So when is it okay to use them?

        ```ruby
        # Why not use them?
        >> foo = false or true    # This expression evaluates to true
        => true
        >> foo                    # But it assigned foo to false
        => false
        # When to use them?
        ```

* Ruby is ...
    * **Interpreted**: No compilation necessary
    * **Object-oriented**: Everything is an object
    * **Strongly typed**: Types must be compatible or _coercible_
    * **Dynamically typed**: Type checking is performed at run-time
    * **Duck typed**: If it looks like a duck and quacks like a duck, it must be a duck. In other words, if an object has a particular method, it doesn't matter what type it is

## Day 1. Self-Study
* Find
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

## Day 2: Floating Down from the Sky
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
    * `push` and `pop` exist natively in the [Array API][Array]

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

    * Alternatively, call a block using `call`. When we do this, the block is actually an instance of [`Proc`][Proc] (short for procedure). The main difference is that a Proc can be stored.

        ```ruby
        def call_block(&block)  # NOTE: block is actually an instance of Proc
          block.call 1, 2
        end
        call_block { |a,b| puts "Hello #{a} and #{b}" } # "Hello 1 and 2"

        def yield_params
          yield 1, 2
        end
        yield_params { |a,b| puts "#{a} and #{b}" } # "1 and 2"

        # Example of instantiating a proc
        someProc = Proc.new do
          # do stuff here
        end
        otherProc = lambda do
          # do other stuff here
        end
        puts someProc.class   # Proc
        puts otherProc.class  # Proc
        ```

    * Useful for policy enforcement, conditional execution, transactions, etc.

* Tree implementation. Note that **attr_accessor** is a synthesizer; it creates instance variables for `@children` and `@node_name`, and it also defines getter and setter methods for the attributes (instance variables).

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
    * [**enumerable**][Enumerable] include the following methods: `sort`, `any?`, `all?`, `collect` (map), `map`, `flat_map`, `select` (filter), `find`, `max`, `min`, `member?`, `inject` (reduce), `reduce`

## Day-2: Self-Study
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

## Day 3: Serious Change
* **Metaprogramming**: writing programs that write programs. _ActiveRecord_ is an Object Relational Model (ORM) that is commonly used in Ruby applications for writing a data abstraction layer for applications.
* **Open classes**: Ruby classes are never closed to modification. You can always add methods to classes at any time; objects that have been instantiated before the modification can use the new methods. This combined with duck typing is very powerful, but also very dangerous.
* `method_missing` is a debugging method that is called whenever a called method is not available. This can be used to develop a rich, reflective API. Be careful, however, because this means you can no longer debug wrong method calls. An example of such an API is shown below:

    ```ruby
    class Roman
      def self.method_missing name, *args
        roman = name.to_s
        roman.gsub!("IV", "IIII")
        roman.gsub!("IX", "VIIII")
        roman.gsub!("XL", "XXXX")
        roman.gsub!("XC", "LXXXX")
        (roman.count("I") +
         roman.count("V") * 5 +
         roman.count("X") * 10 +
         roman.count("L") * 50 +
         roman.count("C") * 100)
      end
    end
    puts Roman.X    # 10
    puts Roman.XC   # 90
    puts Roman.XII  # 12
    puts Roman.IX   # 9
    ```

* **Macro**s and `define_method`: Macros are used to change the behavior of a class depending on the environment, taking advantage of inheritance. In addition we take another look at **module**s and a Ruby idiom commonly used to provide the same functionality via modules.

    ```ruby
    # The inheritance/macro approach:
    class Person
      attr_accessor :name
      def self.can_speak  # This is a class method! Notice the self.
        define_method 'speak' do  # an instance method
          puts "I can talk, my name is #{@name}!"
        end
      end

      def initialize(name)
        @name = name
      end
    end

    class Guy < Person
      can_speak
    end

    class ShyGuy < Person
    end

    john = Guy.new('John')
    bob = ShyGuy.new('Bob')
    john.methods.include?(:speak)   # true
    bob.methods.include?(:speak)    # false

    # The module approach:
    module Person
      attr_accessor :name
      def self.included(base) # included is invoked whenever a module is included; base is implicit
        base.extend ClassMethods  # extend will add the methods defined in ClassMethods as class methods
      end
      module ClassMethods
        def can_speak
          include InstanceMethods # This includes all the instance methods
        end
      end
      module InstanceMethods
        def speak
          puts "I can talk, my name is #{@name}!"
        end
      end
      def initialize(name)
        @name = name
      end
    end

    class Guy
      include Person
      can_speak
    end

    class ShyGuy
      include Person
    end

    john = Guy.new('John')
    bob = ShyGuy.new('Bob')
    john.methods.include?(:speak)   # true
    bob.methods.include?(:speak)    # false
    ```

## Day 3: Self-Study

* Modify the CSV application to support an each method to return a CsvRow object. Use `method_missing` on that CsvRow to return the value for the column for a given heading.

    ```ruby
    # Alternative 1 using method_missing on Hash
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

    # Alternative 2 using a class and Procs
    class Row
      def initialize(row)
        row.each do |k,v|
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

## Wrapping Up
* Strengths
    * Purely object oriented (no primitives)
    * Duck typing for increased polymorphism
    * Can be used somewhat functionally (blocks)
    * Web development (see [Ruby on Rails][RoR])
    * Good for scripting and being productive quickly
    * Prototyping
    * Lots of libraries and gems available
    * Fun?
* Weaknesses
    * Slow (new Ruby VMs try to solve this, see [Rubinius][])
    * Stateful programming due to objects make concurrency hard to get right
    * Duck typing can be dangerous with regards to type safety, and makes it difficult for developer tools (debuggers, IDEs, etc.) to work with Ruby correctly.


<!-- Links -->

[operators]: http://www.techotopia.com/index.php/Ruby_Operator_Precedence#Operator_Precedence_Table
[Ruby API]: http://www.ruby-doc.org
[Programming Ruby]: http://www.ruby-doc.org/docs/ProgrammingRuby/
[gsub]: http://www.ruby-doc.org/core-1.9.3/String.html#gsub-method
[Regex]: http://www.ruby-doc.org/core-1.9.3/Regexp.html
[Range]: http://www.ruby-doc.org/core-1.9.3/Range.html
[Array]: http://www.ruby-doc.org/core-1.9.3/Array.html
[Proc]: http://www.ruby-doc.org/core-1.9.3/Proc.html
[Enumerable]: http://ruby-doc.org/core-1.9.3/Enumerable.html
[RoR]: http://rubyonrails.org/
[Rubinius]: http://rubini.us/
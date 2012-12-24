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
    * Short circuit: `&&`, `and` Whole expression: `&`
    * Short circuit: `||`, `or` Whole expression: `|`
    * `not`, `!`
    * **INSERT CODE EXAMPLE/DEMO**
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
* Expression modifiers
    * `if`, `unless`, `while`, `until`
* Falsy Values
    * everything but `nil` and `false` evaluate to true. `0` is true!

* Ruby is ...
    * **[Interpreted][]**: No compilation necessary, code is executed by an interpreter
    * **[Object-oriented][]**: Everything is an object
    * **[Strongly typed][]**: Types must be compatible or _coercible_
    * **[Dynamically typed][]**: Type checking is performed at run-time
    * **[Duck typed][]**: If it looks like a duck and quacks like a duck, it must be a duck. In other words, if an object has a particular method, it doesn't matter what type it is

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
[Interpreted]: http://en.wikipedia.org/wiki/Interpreted_language
[Object-oriented]: http://en.wikipedia.org/wiki/Object-oriented_programming
[Strongly typed]: http://en.wikipedia.org/wiki/Strong_typing
[Dynamically typed]: http://en.wikipedia.org/wiki/Type_system#Dynamic_typing
[Duck typed]: http://en.wikipedia.org/wiki/Duck_typing
[Array]: http://www.ruby-doc.org/core-1.9.3/Array.html
[Proc]: http://www.ruby-doc.org/core-1.9.3/Proc.html
[Enumerable]: http://ruby-doc.org/core-1.9.3/Enumerable.html
[RoR]: http://rubyonrails.org/
[Rubinius]: http://rubini.us/

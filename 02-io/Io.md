# Io

## Day 1: Skipping School, Hanging Out
* Deal exclusively with objects called _prototypes_. Every object is a clone of an existing object rather an instance created from a class template
* Io syntax chains messages together, with each message returning an object and each message taking optional parameters in parentheses. Everything is a message that returns another receiver.
* In Ruby, you created a new object by calling new on some class. You created a new kind of object by defining a class. Io makes no distinction between the two. You’ll create new objects by cloning existing ones. The existing object is a prototype.
    `Vehicle := Object clone`
* Objects is a collection (hash) of slots
    * Use `object slotName := value` to assign `value` to `slotName` on `object`. If the slot doesn’t exist, Io will create it. Can also use `=` for assignment. If the slot doesn’t exist, Io throws an exception.
    * Access a slot's value or invoke a method by passing a message with the slotName to an object
    * Use `getSlot("slotName")`  to get the contents of a slot
    * Use `method(messages)` to create a method
    * Use `slotNames` to see a list of all slots on an object
    * Every object supports `type` message, which will return the object's prototype. By convention, Types have uppercase names.
        * **INSERT CODE EXAMPLE/DEMO**
    * Use `proto` message to get the prototype of an object
* There’s a master namespace called `Lobby` that contains all the named objects

### Overview

* Every thing is an object
* Every interaction with an object is a message
* You don’t instantiate classes; you clone other objects called prototypes
* Objects remember their prototypes.
* Objects have slots.
* Slots contain objects, including method objects.
* A message returns the value in a slot or invokes the method in a slot.
* If an object can’t respond to a message, it sends that message to its prototype.

### Collections

#### List
Create a list by cloning `List` or with `list(item0, item1, ...)`

##### Methods
* `size`
* `append(element)`
* `prepend(element)`
* `at(index)`
* `isEmpty`
* `sum`
* `average`

#### Map
Create a map by cloning `Map`

##### Methods
* `atPut("key", value)`
* `at("key")`
* `asObject`
* `asList` => list of list(key, value)
* `keys`
* `size`

### Control Structures

#### true, false, nil, and singletons
* logic operators `and` and `or`
* `0` is `true`
* Override the clone slot on an object with itself to create singleton
    * **INSERT CODE EXAMPLE/DEMO**

---

## Day 2: The Sausage King

### Conditionals and Loops
* `loop(messagess)` infinite loop
* A `while` loop takes a condition and a message to evaluate.
```Io
i := 1; while(i <= 11, i println; i = i + 1); "This one goes up to 11" println
```
* The `for` loop takes the name of the counter, the first value, the last value, an optional increment, and a message with sender.
```Io
for(i, 1, 11, i println); "This one goes up to 11" println
```

Both produce the following output:
```
1
2
...
10
11
This one goes up to 11
```

### ifs
`if(condition, true code, false code)`
Or
`if(condition) then(messages) else (messages)`

```Io
Io> if(true, "It is true.", "It is false.")
==> It is true.
Io> if(false) then("It is true") else("It is false")
==> nil
Io> if(false) then("It is true." println) else("It is false." println) It is false.
==> nil
```

### Operators
`OperatorTable` to view the operator table for the current Io instance
`OperatorTable addOperator(name, precedence level)` to add custom operators 

### Message Reflection
A message has three components: the *sender*, the *target*, and the *arguments*. In Io, the *sender* sends a message to a *target*. The *target* executes the message.
`call` gives accesss to a message's meta information
* `call sender`
* `call target`
* `call message name`
* `call message arguments`

Instead of computing the arguments first, Io passes the message itself and the context. Then, the receivers evaluate the message.

`doMessage` executes and arbitrary message
```Io
unless := method(
(call sender doMessage(call message argAt(0))) ifFalse( call sender doMessage(call message argAt(1))) ifTrue( call sender doMessage(call message argAt(2)))
)
```

Example:
```Io
westley princessButtercup unless(trueLove, ("It is false" println), ("It is true" println))
```

1. The object `westley` sends the previous message.
2. Io takes the interpreted message and the context (the call *sender*, *target*, and *message*) and puts it on the stack.
3. Now, `princessButtercup` evaluates the message. There is no `unless` slot, so Io
walks up the prototype chain until it finds `unless`.
4. Io begins executing the `unless` message. First, Io executes `call sender doMessage(call message argAt(0))`. That code simplifies to `westley trueLove`. If you’ve ever seen the movie The Princess Bride, you know that `westley` has a slot called `trueLove`, and the value is `true`.
5. The message is not false, so we’ll execute the third code block, which simplifies to `westley ("It is true" println)`.

### Object Reflection
Keep in mind that an object can have more than one prototype, but we don’t handle this case

```Io
Object ancestors := method(
    prototype := self proto
    if(prototype != Object,
    writeln("Slots of ", prototype type, "\n---------------")
    prototype slotNames foreach(slotName, writeln(slotName))
    writeln
    prototype ancestors))

Animal := Object clone
Animal speak := method("ambiguous animal noise" println)

Duck := Animal clone
Duck speak := method("quack" println)
Duck walk := method("waddle" println)
disco := Duck clone
disco ancestors
```

```
Slots of Duck
---------------
speak
walk
type
Slots of Animal
---------------
speak
type
```

---

## Day 3: The Parade and Other Strange Places

### Domain-Specific Languages

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

if(true, "It is true.", "It is false.")
==> It is true.

if(false) then("It is true") else("It is false")
==> nil

if(false) then("It is true." println) else("It is false." println) It is false.
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

```Io
OperatorTable addAssignOperator(":", "atPutNumber")
curlyBrackets := method(
  r := Map clone
  call message arguments foreach(arg,
       r doMessage(arg)
       )
  r
)

Map atPutNumber := method(
  self atPut(
       call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
       call evalArgAt(1))
)

s := File with("phonebook.txt") openForReading contents
phoneNumbers := doString(s)
phoneNumbers keys   println
phoneNumbers values println
```

### Io's method_missing

```Io
Builder := Object clone
Builder forward := method(
  writeln("<", call message name, ">");
  call message arguments foreach(arg, 
    content := self doMessage(arg); 
    if(content type == "Sequence", writeln(content))
  );
  writeln("</", call message name, ">")
)
Builder ul(
  li("Io"),
  li("Lua"),
  li("JavaScript")
)
```

Output:

```HTML
<ul>
<li>
Io
</li>
<li>
Lua
</li>
<li>
JavaScript
</li>
</ul>
```

HTML Output:

<ul>
<li>
Io
</li>
<li>
Lua
</li>
<li>
JavaScript
</li>
</ul>

### Concurrency

#### Coroutines

A coroutine provides a way for a process to voluntarily suspend (using `yield`) suspend execution and transfer to another process, and then resume execution when other processes `yield`. This is very different from languages like Java or C, which uses *preemptive concurrency*

Fire a message asynchronously:

* `@message` => future
* `@@message` => nil and starts the message in its own thread

Coroutines are great for **cooperative multitasking**

```Io
vizzini := Object clone
vizzini talk := method(
            "Fezzik, are there rocks ahead?" println
            yield 
            "No more rhymes now, I mean it." println
             yield)

fezzik := Object clone

fezzik rhyme := method(
      yield
            "If there are, we'll all be dead." println
            yield 
            "Anybody want a peanut?" println)

vizzini @@talk; fezzik @@rhyme

Coroutine currentCoroutine pause # wait until all async messages complete and then exits.
```

Output:

```
Fezzik, are there rocks ahead?
If there are, we'll all be dead.
No more rhymes now, I mean it.
Anybody want a peanut?
Scheduler: nothing left to resume so we are exiting
```

#### Actors

Actors as universal concurrent primitives that can send messages, process messages, and create other actors. The messages an actor receives are concurrent. In Io, an actor places an incoming message on a queue and processes the contents of the queue with [coroutines][].

Actors have a huge theoretical advantage over threads. An actor changes its own state and accesses other actors only through closely controlled queues. Threads can change each other’s state without restriction. Threads are subject to a concurrency problem called *race conditions*, where two threads access resources at the same time, leading to unpredictable results.

```Io
slower := Object clone
faster := Object clone 
slower start := method(wait(2); writeln("slowly"))
faster start := method(wait(1); writeln("quickly"))

> slower start; faster start # sequential
slowly
quickly
==> nil 
> slower @@start; faster @@start; wait(3) # parallel in each thread
quickly
slowly
```

Make objects actors by simply sending an asynchronous message to them. Each thread can only alter its own state

#### Futures

A future is a result object that is immediately returned from an asynchronous message call. Since the message may take a while to process, the future becomes the result once the result is available. If you ask for the value of a future before the result is available, the process blocks until the value is available. The value is a `Future` object until the result arrives, and then all instances of the value point to the result object.

`Futures` in Io also provide automatic deadlock detection.

```Io
futureResult := URL with("http://google.com/") @fetch
writeln("Do something immediately while fetch goes on in background...")
# blocks until future returns
writeln("fetched ", futureResult size, " bytes") 
```

Output:

```
Do something immediately while fetch goes on in background...
fetched 4894 bytes
```

## Wrapping Up

### Strengths
* Malleable, allow for creation of custom syntax
* Small Footprint
* Compact, simple, easy to learn syntax
* Duck typing and freedom allow for basic rules of the language to be tweaked or changed to suit your needs. Easy to add proxies by overriding the `forward` slot
* Concurrency constructs make it easier to build and test performant multi-threaded applications

### Weaknesses
* Small community
* Little syntactical sugar
* Some features will slow raw, single threaded performance

# Io

## Day 1: Skipping School, Hanging Out

### Find
* Some Io example problems
  [c2 wiki](http://c2.com/cgi/wiki?IoLanguage)
  [Wikipedia](http://en.wikipedia.org/wiki/Io_(programming_language))
  [IoGuide](http://iolanguage.org/scm/io/docs/IoGuide.html)

* An Io community that will answer questions
  [Yahoo Group](http://tech.groups.yahoo.com/group/iolanguage/messages)
  [Stackoverflow](http://stackoverflow.com/questions/tagged/iolanguage)
  \#io on freenode
  [Sub Reddit](http://www.reddit.com/r/iolanguage)

* A style guide with Io idioms
  [Style Guide](http://en.wikibooks.org/wiki/Io_Programming/Io_Style_Guide)

### Answer

**Evaluate `1 + 1` and then `1 + "one"`. Is Io strongly typed or weakly typed? Support your answer with code.**

```Io
1+1
==> 2
1+"one"
==> "Exception: argument 0 to method '+' must be a Number, not a 'Sequence'""
```

Strongly typed

**Is 0 true or false? What about the empty string? Is nil true or false? Support your answer with code.**

```Io
(0 and true) and (0 or false)
==> true

("" and true) and ("" or false)
==> true

(nil and true) and (nil or false)
==> false
```

**How can you tell what slots a prototype supports?**

`prototype slotNames` or `prototype slotSummary`

**What is the difference between `=` (equals), `:=` (colon equals), and `::=` (colon colon equals)? When would you use each one?**

`::=` Creates slot, creates setter, assigns value
`:=`  Creates slot, assigns value
`=`   Assigns value to slot if it exists, otherwise raises exception 

### Do

**Run an Io program from a file.**

`io animal.io`

**Execute the code in a slot given its name.**

If declared in `Lobby`, then `slotName(params)`
If declared on an object, then`object slotName(params)`

---

## Day 2: The Sausage King

### Do

1. A Fibonacci sequence starts with two 1s. Each subsequent number is the sum of the two numbers that came before: 1, 1, 2, 3, 5, 8, 13, 21, and so on. Write a program to find the nth Fibonacci number. fib(1) is 1, and fib(4) is 3. As a bonus, solve the problem with recursion and with loops.

    ```Io
    # Head recursion
    fib := method(n, if(n <= 2, 1, fib(n - 1), fib(n - 2)))
    # Tail recursion
    fibTail := method(n, a, b, if(n <= 2, b, fibTail(n - 1, b, a + b)))
    # Loop
    fibLoop := method(n, a := 1; b := 1; temp := 0, for(i, 3, n, temp = a + b; a = b; b = temp); b)
    ```

2. How would you change / to return 0 if the denominator is zero?

    ```Io
    div := Number getSlot("/")
    Number / = method(denom, if(denom == 0, 0, div(denom)))

    4 / 2
    ==> 2
    4 / 0
    ==> 0
    ```

3. Write a program to add up all of the numbers in a two-dimensional array.
    ```Io
    List flatSum := method(self flatten sum)
    list(
        list(1, 2, 3),
        list(4, 5, 6),
        list(7, 8, 9)
    ) flatSum
    ==> 45
    ```

4. Add a slot called myAverage to a list that computes the average of all the numbers in a list. What happens if there are no numbers in a list? (Bonus: Raise an Io exception if any item in the list is not a number.)

    ```Io
    List myAverage := method(
      if(self size == 0) then(return nil);
      foreach(i, item,
        if(item type != "Number")
        then(
          Exception raise(list("list[", i, "]:", item, "is not a number") join(" "))
        )
      );
      self average
    )

    list() myAverage
    ==> nil
    list(1, 2, 3) myAverage
    ==> 2
    list(1, 2, 3, "a") myAverage
    Exception: list[ 3 ]: a is not a number
    ```

5. Write a prototype for a two-dimensional list. The dim(x, y) method should allocate a list of y lists that are x elements long. set(x, y, value) should set a value, and get(x, y) should return that value.
6. Bonus: Write a transpose method so that (new_matrix get(y, x)) == matrix get(x, y) on the original list.
7. Write the matrix to a file, and read a matrix from a file.
  
    ```Io
    Matrix := List clone

    Matrix dim := method(x, y,
      matrix := Matrix clone;
      for(i, 1, y, matrix append(list() setSize(x)));
      matrix
    )

    Matrix row := method(self size)
    Matrix column := method(if(self first == nil, 0, self first size))

    Matrix set := method(x, y, value,
      self at(y) atPut(x, value);
      self
    )

    Matrix get := method(x, y, value,
      self at(y) at(x)
    )

    Matrix transpose := method(
      row := self row
      column := self column

      tmatrix := Matrix dim(column, row)

      for(i, 0, column - 1,
        for(j, 0, row - 1,
          tmatrix set(i, j, self get(j, i))
        )
      )

      tmatrix
    )

    Matrix saveToFile := method(filename,
      f := File with(filename)
      f remove
      f openForUpdating
      f write(
        self map(row, row join(",")) join("\n")
      )
      f close
    );

    Matrix readFromFile := method(filename,
      matrix := Matrix clone;
      f := File with(filename)
      f openForReading
      f readLines foreach(i, row, matrix append(row split(",")))
      f close
      matrix
    );

    nm := Matrix clone

    m := Matrix dim(2, 2) set(0, 0, 1) set(0, 1, 2) set(1, 0, 3) set(1, 1, 4)
    m println
    tm := m transpose
    tm println
    (tm get(0, 1) == m get(1, 0)) println

    m saveToFile("matrix.data")
    m readFromFile("matrix.data") println
    ```

8. Write a program that gives you ten tries to guess a random number from 1–100. If you would like, give a hint of “hotter” or “colder” after the first guess.

    ```Io
    min := 1
    max := 100

    random := (Random value(max - min) + min) floor
    stdin := File standardInput

    lastGuess := nil
    guess := 0
    diff := 0

    10 repeat(
      writeln("Guess a number between ", min, " and ", max)
      guess = stdin readLine asNumber
      diff = (guess - random) abs

      if(diff == 0) then(
        break;
      ) else(
        if(lastGuess) then(
          if (diff < lastGuess) then(
            "warmer" println
          ) else(
            "colder" println
          )
        )
        lastGuess = diff
      )
    )

    writeln("The number is ", random)
    ```

---

## Day 3: The Parade and Other Strange Places

### Do

**Enhance the XML program to add spaces to show the indentation structure.**
**Enhance the XML program to handle attributes: if the first argument is a map (use the curly brackets syntax), add attributes to the XML program. For example: `book({"author": "Tate"}...)` would print `<book author="Tate">`**

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
    call evalArgAt(1)
  )
)

Builder := Object clone

indentation := "\t"
Builder prefix := "" asMutable
Builder indent := method(
  self prefix appendSeq(indentation)
)
Builder unindent := method(
  self prefix removeSuffix(indentation)
)
Builder writeIndent := method(
  write(self prefix)
)
Builder writeln := method(
  args := call message argsEvaluatedIn(call sender)
  writeln(self prefix, args join(""))
)

Builder forward := method(
  args := call message arguments
  if (args first and args first name == "curlyBrackets") then(
    m := doString(args first asString)
    self writeIndent
    write("<", call message name);
    m foreach(key, value,
      write(" ",key, "=\"", value, "\"")
    )
    writeln(">");
    args = args rest
  ) else (
    self writeln("<", call message name, ">");
  )
  self indent
  args foreach(arg,
    content := self doMessage(arg);
    if(content type == "Sequence", self writeln(content))
  );
  self unindent
  self writeln("</", call message name, ">")
)

Builder div(
  {
    "class": "container",
    "id": "top_container"
  },
  h3({ "class": "header" },"Io is awesome"),
  div(
    h5("Prototype Languages"),
    ul(
      { "class": "list" },
      li("Io"),
      li("Lua"),
      li("JavaScript")
    )
  )
)
```

**Create a list syntax that uses brackets.**

```Io
squareBrackets := method(
  list() appendSeq(call message arguments)
)

s := File with("list.txt") openForReading contents
l := doString(s)
l println
l size println
```
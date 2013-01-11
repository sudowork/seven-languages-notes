# Prolog

Prolog is a **declarative** language: a language where you don't specify the control flow, as opposed to **imperative** languages. Specifically, Prolog belongs to a subset of declarative languages call **logic** programming languages. Prolog bases its computations on programmer-provided facts and inferences; it then deduces the result.

* **Facts** A fact is a basic assertion about some world. (*Babe is a pig; pigs like mud.*)
* **Rules** A rule is an inference about the facts in that world. (*An animal likes mud if it is a pig.*)
* **Query** A query is a question about that world. (*Does Babe like mud?*)

*Facts* and *rules* will go into a *knowledge base*. A Prolog compiler compiles the knowledge base into a form that’s efficient for *queries*.

## Day 1: An Excellent Driver
**atom**: word that begins with a *lowercase* letter
**variable** word that begins with a *uppercase* letter or an *underscore*

Let's state some **fact**s (alice likes chocolate, etc.):

```prolog
% format of a fact: <predicate>(<atom>, ...).
likes(alice, chocolate).
likes(bob, cheese).
likes(charlie, chocolate).
likes(charlie, cheese).
```

And now let's write a **rule**:

```prolog
friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).
```

The above rule is called `friend/2` (name of friend and takes two parameters).
`X`, `Y`, and `Z` are variables.
The `:-` is the declaration operator. In this case, we are declaring a rule.
Everything to the right of the `:-` are considered the **subgoal**s. The subgoals are separated by a `,`, this signifies a logical *AND*.
`\+` is the negation operator. We are stating that `X` cannot equal `Y`; you cannot be a friend of yourself.
The two other subgoals are that `X` must like atom `Z`, and in addition, `Y` must also like atom `Z`. Note that `X` and `Y` may be the same atom, which is why we include the previous subgoal. At the same time `Z` must be the same for both of the latter two subgoals.

Finally, let's write some queries:

```prolog
% Let's find out if these people are friends.
friend(alice, alice).   % no
friend(alice, bob).     % no
friend(alice, charlie). % yes
friend(bob, charlie).   % yes
friend(charlie, bob).   % yes
```

For the query `friend(alice, alice)`. This query violates the first subgoal where `X` cannot equal `Y`; therefore, no is returned.

For the query `friend(bob, charlie)`:

* Prolog must try multiple values for `X`, `Y`, and `Z` respectively: `bob, charlie, chocolate` and `bob, charlie, cheese`.
* Examining the first set of values, we see that `likes(Y, Z)` is true, but `likes(X, Z)` is false. So this cannot be a valid set of values for the variables.
* Looking at the next set of values, we see that all three subgoals hold true, so Prolog returns `yes`.

What if we don't want a yes or no answer? We can ask "What" or "Who".

```prolog
% Let's find out who likes cheese.
likes(Who, cheese). % The interpreter will show one result,
                    % then expect either ;, a, or RETURN after executing the query
% A variable can be anything that starts with a capital letter
likes(X, chocolate).
```

Cool! But what if I want to know who's friends with Bob (remember, `friend` is a rule, not a fact).

```prolog
friend(bob, Who). % uh-oh, this doesn't work as expected
% We have to reorder the subgoals in the friend rule
friend(X, Y) :- likes(X, Z), likes(Y, Z), \+(X = Y).
% Now the query works as expected
friend(bob, Who).
```

Why did we have to do that? Prolog tries to fulfill subgoals in left-to-right order. Notice that the first subgoal was `\+(X = Y)`. It happens that the expression `<variable> = <atom>` or vice-versa evaluates to `yes`; therefore, the negation of that evaluates to `no`. So the first subgoal always fails to pass. We need Prolog to first identify possible values for the variable, which is why that subgoal has to be last.

### Map Coloring
We want to color the Southeastern states, but each bordering state must be a different color.

First, let's declare our colors and state which ones are different:

```prolog
% Notice that order matters, so we have duplicate combinations
different(red, green). different(red, blue).
different(green, red). different(green, blue).
different(blue, red). different(blue, green).
```

Next, let's create a rule that enforces each bordering state is different.

```prolog
coloring(Alabama, Mississippi, Georgia, Tennessee, Florida) :-
  different(Mississippi, Tennessee),
  different(Mississippi, Alabama),
  different(Alabama, Tennessee),
  different(Alabama, Mississippi),  % This one is unnecessary (redundant information)
  different(Alabama, Georgia),
  different(Alabama, Florida),
  different(Georgia, Florida),
  different(Georgia, Tennessee).
```

Let's run a query to get all possible color combinations:

```prolog
| ?- coloring(Alabama, Mississippi, Georgia, Tennesse
e, Florida).

Alabama = blue
Florida = green
Georgia = red
Mississippi = red
Tennessee = green ? a
...
```

What if we want to enforce that Alabama must be red?

```prolog
| ?- coloring(Alabama, Mississippi, Georgia, Tennesse
e, Florida), Alabama = red.

Alabama = red
Florida = blue
Georgia = green
Mississippi = green
Tennessee = blue ? a
...
```


So, when should I use Prolog? Have you ever run into a situation where you have a bunch of possible choices, but you need to pick one or more combinations of values that satisfy a particular problem? Prolog takes care of the algorithmic part of it for you, you just have to put in the constraints!
**<a href="#unification">Unification</a>**: Unification is performed through the `=` operator. And it can be thought of as assignment. It is enforcing that the left and right side of the `=` operator are equivalent in the solution.

---

## Day 2: Fifteen Minutes to Wapner

**Recursion**: How do we achieve recursion? We recursively include a subgoal in a rule. For example:

```prolog
father(zeb, john_boy_sr).
father(john_boy_sr, john_boy_jr).
ancestor(X, Y) :- father(X, Y). % "base case"
ancestor(X, Y) :- father(X, Z), ancestor(Z, Y). % some links Z between X and Y
```

* When we have two clauses, for the `ancestor` rule in this case, only one clause must be true for the rule to be true. Alternatively, we could have expressed this as a single clause using a logical or `;`.

```prolog
ancestor(X, Y) :- father(X, Y);
                  father(X, Z), ancestor(Z, Y).
```

Alright, so let's write some queries to find out if someone is another person's ancestor. We can also figure out who all the ancestors of a person are, and who all the descendents of a person are using this single rule.

```prolog
ancestor(zeb, john_boy_sr). % satisfies first clause
ancestor(zeb, john_boy_jr). % satisfies recursive clause
ancestor(zeb, Who).         % All descendents of zeb
ancestor(Who, john_boy_jr). % All ancestors of john_boy_jr
```

Quick note about recursion. Often times, with a data structure or relationship deep enough, recursion will cause a **stack overflow**; in other words, each recursive call results in more space being used on the stack. If we can write our recursive call at the end of the sub-routine, we call this a **tail call**. When something is **tail-recursive**, it can be implemented without adding new stack frames to the stack (basically turning a recursive call into a loop).

### Tuples

* A data type consisting of multiple sub parts
* Can be declared in Prolog with the following syntax: `(1, 2, 3).`. Note that order matters.
* Let's try unification with tuples

```prolog
(1, 2, 3) = (1, 2, 3).  % yes
(1, 2, 3) = (3, 2, 1).  % no
(1, 2, 3) = (A, B, C).  % A = 1, B = 2, C = 3
(A, 2, C) = (1, B, 3).  % A = 1, B = 2, C = 3; unification is commutative
(X, X, Y) = (1, 1, 2).  % X = 1, Y = 2
(X, X, Y) = (1, 2, 3).  % no
```

### Lists
* Constructed by `[1, 2, 3]`.
* Works similar to tuples (all the examples above would be the same if you replaced the parentheses with square brackets).
* Deconstruction of a list into its head and tail can be done using the following: `[1, 2, 3] = [Head | Tail].`. In this situation, Prolog will assign `Head = 1` and `Tail = [2,3]`. Note that this unification only works if the list size is at least 1. An empty list won't unify.
* What if we want the third element and beyond but don't care about the first two element values. We can use the wildcard `_` for the first two elements and then grab the third value and tail. `[a, b, c, d, e, f] = [_, _, Third | Tail].`

Let's write some predicates that do some math on lists! We will handle `count`ing, `sum`ming, and `average`-ing:

```prolog
count(0, []). % base case
count(Count, [Head|Tail]) :- count(TailCount, Tail), Count is TailCount + 1. % we recursively call count on the tail of the list, and add 1 each time

sum(0, []).   % base case
sum(Sum, [Head|Tail]) :- sum(TailSum, Tail), Sum is TailSum + Head. % we use the same method here

% Let's include product for fun
product(1, []).
product(Product, [Head|Tail]) :- product(TailProd, Tail), Product is TailProd * Head.

average(Average, List) :- sum(Sum, List), count(Count, List), Average is Sum / Count. % we take the sum and count and then take the average
```

Just for kicks, can we make `count` tail-recursive?

```prolog
count(Count, List) :- count(Count, List, 0).  % Alias count/2 to count/3
count(Count, [], A) :- Count is A.  % A is an accumulator
count(Count, [H|T], A) :- count(Count, T, A + 1). % Increment the parameter A with every sub-call
```

Let's talk about `append/3`. It's a rule that takes in three lists, let's call them `A`, `B`, and `C`. `append` will yield `yes` if `A + B = C`. So now what can we do with this rule?

* Build lists: `append([a, b, c], [1, 2, 3], C). % C = [a, b, c, 1, 2, 3]`
* Subtract lists: `append([a, b], What, [a, b, c]). % What = [c]` (Note that order matters)
* Permute lists: `append(A, B, [a, b, c]).`

Reimplementing `append/3` as `concat/3`:

```prolog
concatenate([], List, List).
concatenate([Head|Tail1], List, [Head|Tail2]) :- concatenate(Tail1, List, Tail2).
```

---

## Day 3: Blowing Up Vegas

### Sudoku
`fd_domain(List, LowerBound, UpperBound)`: this predicate is true if all the values in `List` are between `LowerBound` and `UpperBound`, inclusive.

`fd_all_different(List)`: this predicate is true if all values in `List` are all different

```prolog
valid([]).
valid([Head|Tail]) :-
  fd_all_different(Head),
  valid(Tail).

sudoku(Puzzle, Solution) :-
  Solution = Puzzle,
  Puzzle = [
    S11, S12, S13, S14,
    S21, S22, S23, S24,
    S31, S32, S33, S34,
    S41, S42, S43, S44
  ],
  fd_domain(Solution, 1, 4),
  Row1 = [S11, S12, S13, S14],
  Row2 = [S21, S22, S23, S24],
  Row3 = [S31, S32, S33, S34],
  Row4 = [S41, S42, S43, S44],
  Col1 = [S11, S21, S31, S41],
  Col2 = [S12, S22, S32, S42],
  Col3 = [S13, S23, S33, S43],
  Col4 = [S14, S24, S34, S44],
  Square1 = [S11, S12, S21, S22],
  Square2 = [S13, S14, S23, S24],
  Square3 = [S31, S32, S41, S42],
  Square4 = [S33, S34, S43, S44],
  valid([
    Row1, Row2, Row3, Row4,
    Col1, Col2, Col3, Col4,
    Square1, Square2, Square3, Square4
  ]).
```

### Eight Queens
`length(List, N)` succeeds if `List` has `N` elements

`member(M, List)` succeeds if `M` is a member of `List`

\* Alternatively, you can do `fd_domain(M, 1, 8)` in this case

Diagonals

```prolog
diags1([], []).
diags1([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
  Diagonal is Col - Row,
  diags1(QueensTail, DiagonalsTail).

diags2([], []).
diags2([(Row, Col)|QueensTail], [Diagonal|DiagonalsTail]) :-
  Diagonal is Col + Row,
  diags2(QueensTail, DiagonalsTail).
```

|       |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **1** | 11  | 12  | 13  | 14  | 15  | 16  | 17  | 18  |
| **2** | 22  | 22  | 23  | 24  | 25  | 26  | 27  | 28  |
| **3** | 33  | 32  | 33  | 34  | 35  | 36  | 37  | 38  |
| **4** | 44  | 42  | 43  | 44  | 45  | 46  | 47  | 48  |
| **5** | 55  | 52  | 53  | 54  | 55  | 56  | 57  | 58  |
| **6** | 66  | 62  | 63  | 64  | 65  | 66  | 67  | 68  |
| **7** | 77  | 72  | 73  | 74  | 75  | 76  | 77  | 78  |
| **8** | 88  | 82  | 83  | 84  | 85  | 86  | 87  | 88  |

|                         **Diag1**             |||||||||
|       |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **1** | 1+1 | 1+2 | 1+3 | 1+4 | 1+5 | 1+6 | 1+7 | 1+8 |
| **2** | 2+1 | 2+2 | 2+3 | 2+4 | 2+5 | 2+6 | 2+7 | 2+8 |
| **3** | 3+1 | 3+2 | 3+3 | 3+4 | 3+5 | 3+6 | 3+7 | 3+8 |
| **4** | 4+1 | 4+2 | 4+3 | 4+4 | 4+5 | 4+6 | 4+7 | 4+8 |
| **5** | 5+1 | 5+2 | 5+3 | 5+4 | 5+5 | 5+6 | 5+7 | 5+8 |
| **6** | 6+1 | 6+2 | 6+3 | 6+4 | 6+5 | 6+6 | 6+7 | 6+8 |
| **7** | 7+1 | 7+2 | 7+3 | 7+4 | 7+5 | 7+6 | 7+7 | 7+8 |
| **8** | 8+1 | 8+2 | 8+3 | 8+4 | 8+5 | 8+6 | 8+7 | 8+8 |

|                         **Diag1**             |||||||||
|       |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **1** |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |
| **2** |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  10 |
| **3** |  4  |  5  |  6  |  7  |  8  |  9  |  10 |  11 |
| **4** |  5  |  6  |  7  |  8  |  9  |  10 |  11 |  12 |
| **5** |  6  |  7  |  8  |  9  |  10 |  11 |  12 |  13 |
| **6** |  7  |  8  |  9  |  10 |  11 |  12 |  13 |  14 |
| **7** |  8  |  9  |  10 |  11 |  12 |  13 |  14 |  15 |
| **8** |  9  |  10 |  11 |  12 |  13 |  14 |  15 |  16 |

|                         **Diag2**             |||||||||
|       |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **1** | 1-1 | 2-1 | 3-1 | 4-1 | 5-1 | 6-1 | 7-1 | 8-1 |
| **2** | 1-2 | 2-2 | 3-2 | 4-2 | 5-2 | 6-2 | 7-2 | 8-2 |
| **3** | 1-3 | 2-3 | 3-3 | 4-3 | 5-3 | 6-3 | 7-3 | 8-3 |
| **4** | 1-4 | 2-4 | 3-4 | 4-4 | 5-4 | 6-4 | 7-4 | 8-4 |
| **5** | 1-5 | 2-5 | 3-5 | 4-5 | 5-5 | 6-5 | 7-5 | 8-5 |
| **6** | 1-6 | 2-6 | 3-6 | 4-6 | 5-6 | 6-6 | 7-6 | 8-6 |
| **7** | 1-7 | 2-7 | 3-7 | 4-7 | 5-7 | 6-7 | 7-7 | 8-7 |
| **8** | 1-8 | 2-8 | 3-8 | 4-8 | 5-8 | 6-8 | 7-8 | 8-8 |

|                         **Diag2**             |||||||||
|       |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **1** |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
| **2** |  -1 |  0  |  1  |  2  |  3  |  4  |  5  |  6  |
| **3** |  -2 |  -1 |  0  |  1  |  2  |  3  |  4  |  5  |
| **4** |  -3 |  -2 |  -1 |  0  |  1  |  2  |  3  |  4  |
| **5** |  -4 |  -3 |  -2 |  -1 |  0  |  1  |  2  |  3  |
| **6** |  -5 |  -4 |  -3 |  -2 |  -1 |  0  |  1  |  2  |
| **7** |  -6 |  -5 |  -4 |  -3 |  -2 |  -1 |  0  |  1  |
| **8** |  -7 |  -6 |  -5 |  -4 |  -3 |  -2 |  -1 |  0  |

## Wrapping Up

Prolog works with knowledge bases, composed of logical facts and inferences about various problem domains. Queries can be made on the knowledge bases assertions, which will be resolved through [unification][] that makes variables on both sides of a system match

### Strengths

Applicable for a variety of problems:

* Natural-Language Processing - understand inexact language
* Games - more complex and adaptable characters and environment
* Semantic Web - rich user experience
* Artificial Intelligence - model formal logic
* Scheduling - excel in working with constrained resources

### Weaknesses

* Focused on niche, logic proramming instead of general-purpose use, and therefore has some limitations related to language design
* Uses a depth-first search of a decision tree, using all possible combinations matched against the set of rules. Large data sets can be particularly computationally intensive
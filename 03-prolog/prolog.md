# Prolog

Prolog is a **declarative** language: a language where you don't specify the control flow, as opposed to **imperative** languages. Specifically, Prolog belongs to a subset of declarative languages call **logic** programming languages. Prolog bases its computations on programmer-provided facts and inferences; it then deduces the result.

So how do you write a Prolog program? You define a set of assertions, **facts**, and Prolog will tell you if they're true. Even more powerful, is that if you leave gaps in your assertions, sprinkled with a few **rule**s, you can then **query** prolog and it will fill in the gaps for you.

## Day 1: An Excellent Driver
* Prolog is pretty simply; it's either a `yes` or a `no` (for now at least).
* Let's state some **fact**s (alice likes chocolate, etc.):

    ```prolog
    % format of a fact: <predicate>(<atom>, ...).
    likes(alice, chocolate).
    likes(bob, cheese).
    likes(charlie, chocolate).
    likes(charlie, cheese).
    ```

* And now let's write a **rule**:

    ```prolog
    friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).
    ```

    * The above rule is called `friend/2` (name of friend and takes two parameters).
    * `X`, `Y`, and `Z` are variables.
    * The `:-` is the declaration operator. In this case, we are declaring a rule.
    * Everything to the right of the `:-` are considered the **subgoal**s. The subgoals are separated by a `,`, this signifies a logical AND.
    * `\+` is the negation operator. We are stating that `X` cannot equal `Y`; you cannot be a friend of yourself.
    * The two other subgoals are that `X` must like atom `Z`, and in addition, `Y` must also like atom `Z`. Note that `X` and `Y` may be the same atom, which is why we include the previous subgoal. At the same time `Z` must be the same for both of the latter two subgoals.

* Finally, let's write some queries:

    ```prolog
    % Let's find out if these people are friends.
    friend(alice, alice).   % no
    friend(alice, bob).     % no
    friend(alice, charlie). % yes
    friend(bob, charlie).   % yes
    friend(charlie, bob).   % yes
    ```

    * Let's take a closer look at the query `friend(alice, alice)`. This query violates the first subgoal where `X` cannot equal `Y`; therefore, no is returned.
    * Let's take a closer look at the query `friend(bob, charlie)`:
        * Prolog must try multiple values for `X`, `Y`, and `Z` respectively: `bob, charlie, chocolate` and `bob, charlie, cheese`.
        * Examining the first set of values, we see that `likes(Y, Z)` is true, but `likes(X, Z)` is false. So this cannot be a valid set of values for the variables.
        * Looking at the next set of values, we see that all three subgoals hold true, so Prolog returns `yes`.

* What if we don't want a yes or no answer? We can ask "What" or "Who".

    ```prolog
    % Let's find out who likes cheese.
    likes(Who, cheese).  % The interpreter will show one result,
                          % then expect either ;, a, or RETURN after executing the query
    % A variable can be anything that starts with a capital letter
    likes(X, chocolate).
    ```

* Cool! But what if I want to know who's friends with Bob (remember, `friend` is a rule, not a fact).

    ```prolog
    friend(bob, Who). % uh-oh, this doesn't work as expected
    % We have to reorder the subgoals in the friend rule
    friend(X, Y) :- likes(X, Z), likes(Y, Z), \+(X = Y).
    % Now the query works as expected
    friend(bob, Who).
    ```

    * Why did we have to do that? Prolog tries to fulfill subgoals in left-to-right order. Notice that the first subgoal was `\+(X = Y)`. It happens that the expression `<variable> = <atom>` or vice-versa evaluates to `yes`; therefore, the negation of that evaluates to `no`. So the first subgoal always fails to pass. We need Prolog to first identify possible values for the variable, which is why that subgoal has to be last.

* Let's try a slightly bigger example. We want to color the Southeastern states, but each bordering state must be a different color.
    * First let's declare our colors and state which ones are different:

        ```prolog
        % Notice that order matters, so we have duplicate combinations
        different(red, green). different(red, blue).
        different(green, red). different(green, blue).
        different(blue, red). different(blue, green).
        ```

    * Next, let's create a rule that enforces each bordering state is different.

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

    * Let's run a query to get all possible color combinations:

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

    * What if we want to enforce that Alabama must be red?

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

* So, when should I use Prolog? Have you ever run into a situation where you have a bunch of possible choices, but you need to pick one or more combinations of values that satisfy a particular problem? Prolog takes care of the algorithmic part of it for you, you just have to put in the constraints!
* **Unification**: Unification is performed through the `=` operator. And it can be thought of as assignment. It is enforcing that the left and right side of the `=` operator are equivalent in the solution.

## Day 1: Self-Study
* Find:
    * Some free Prolog tutorials
        * [Prolog tutorial by J.R. Fisher](http://www.csupomona.edu/~jrfisher/www/prolog_tutorial/contents.html)
        * [Prolog tutorial by A. Aaby](http://www.lix.polytechnique.fr/~liberti/public/computing/prog/prolog/prolog-tutorial.html)
        * [A short prolog tutorial](http://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/)
        * [Learn Prolog Now!](http://www.learnprolognow.org/lpnpage.php?pageid=online)
        * Many more (just google it)
    * A support forum
        * [Old Nabble - Gnu - Prolog forum](http://old.nabble.com/Gnu---Prolog-f1818.html)
        * [Stack Overflow - Prolog tag](http://stackoverflow.com/tags/prolog/info)
    * One online reference for the Prolog version you're using
        * [GNU-Prolog Manual](http://stackoverflow.com/tags/prolog/info)
* Do:

    ```prolog
    % Make a simple knowledge base. Represent some of your favorite books and authors.
    wrote(charles_dickens, a_tale_of_two_cities).
    wrote(j_r_r_tolkien, the_hobbit).
    wrote(j_r_r_tolkien, the_lord_of_the_rings).
    wrote(dan_brown, the_da_vinci_code).
    wrote(dan_brown, angels_and_demons).
    wrote(e_b_white, charlottes_web).
    wrote(j_k_rowling, harry_potter).

    % Find all books in your knowledge base written by one author.
    wrote(dan_brown, What).

    % Make a knowledge base representing musicians and instruments.
    % Also represent musicians and their genre of music.
    plays(bob_marley, guitar).
    plays(kurt_cobain, guitar).
    plays(eddie_van_halen, guitar).
    plays(stevie_wonder, piano).
    plays(ludwig_van_beethoven, piano).
    plays(frederic_chopin, piano).
    plays(franz_liszt, piano).
    plays(ringo_starr, drums).
    plays(travis_barker, drums).
    plays(kesha, autotune).
    genre(bob_marley, reggae).
    genre(kurt_cobain, rock).
    genre(eddie_van_halen, rock).
    genre(stevie_wonder, soul).
    genre(ludwig_van_beethoven, classical).
    genre(frederic_chopin, classical).
    genre(franz_liszt, classical).
    genre(ringo_starr, rock).
    genre(travis_barker, rock).
    genre(kesha, pop).

    % Find all musicians who play the guitar.
    plays(Who, guitar).

    % Bonus: Find all genres where guitar is played.
    plays(X, guitar), genre(X, Genre).
    ```

## Day 2: Fifteen Minutes to Wapner
* **Recursion**: How do we achieve recursion? We recursively include a subgoal in a rule. For example:

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

* Alright, so let's write some queries to find out if someone is another person's ancestor. We can also figure out who all the ancestors of a person are, and who all the descendents of a person are using this single rule.

    ```prolog
    ancestor(zeb, john_boy_sr). % satisfies first clause
    ancestor(zeb, john_boy_jr). % satisfies recursive clause
    ancestor(zeb, Who).         % All descendents of zeb
    ancestor(Who, john_boy_jr). % All ancestors of john_boy_jr
    ```

* Quick note about recursion. Often times, with a data structure or relationship deep enough, recursion will cause a **stack overflow**; in other words, each recursive call results in more space being used on the stack. If we can write our recursive call at the end of the sub-routine, we call this a **tail call**. When something is **tail-recursive**, it can be implemented without adding new stack frames to the stack (basically turning a recursive call into a loop). Tail call optimization is incredibly important, and we'll talk about it more later.
* Other data types in Prolog:
    * **Tuples**
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

    * **Lists**
        * Constructed by `[1, 2, 3]`.
        * Works similar to tuples (all the examples above would be the same if you replaced the parentheses with square brackets).
        * Deconstruction of a list into its head and tail can be done using the following: `[1, 2, 3] = [Head | Tail].`. In this situation, Prolog will assign `Head = 1` and `Tail = [2,3]`. Note that this unification only works if the list size is at least 1. An empty list won't unify.
        * What if we want the third element and beyond but don't care about the first two element values. We can use the wildcard `_` for the first two elements and then grab the third value and tail. `[a, b, c, d, e, f] = [_, _, Third | Tail].`
    * Let's write some predicates that do some math on lists! We will handle `count`ing, `sum`ming, and `average`-ing:

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

    * Just for kicks, can we make `count` tail-recursive?

      ```prolog
      count(Count, List) :- count(Count, List, 0).  % Alias count/2 to count/3
      count(Count, [], A) :- Count is A.  % A is an accumulator
      count(Count, [H|T], A) :- count(Count, T, A + 1). % Increment the parameter A with every sub-call
      ```

    * Let's talk about `append/3`. It's a rule that takes in three lists, let's call them `A`, `B`, and `C`. `append` will yield `yes` if `A + B = C`. So now what can we do with this rule?
        * Build lists: `append([a, b, c], [1, 2, 3], C). % C = [a, b, c, 1, 2, 3]`
        * Subtract lists: `append([a, b], What, [a, b, c]). % What = [c]` (Note that order matters)
        * Permute lists: `append(A, B, [a, b, c]).`

    * Reimplementing `append/3` as `concat/3`:

## Day 2: Self-Study
* Find:
    * ~~Some implementations of a Fibonacci series and factorials.~~ Write an implementation of Fibonacci series and factorials.

        ```prolog
        % Fibonacci by definition (positives only)
        fib(0, 0).
        fib(1, 1).
        fib(F, N) :-
          N1 is N - 1,  % Alternatively, we could use succ(N1, N)
          N2 is N - 2,  % similarly succ(N2, N1); succ(A, B) means B = A + 1
          fib(F1, N1),
          fib(F2, N2),
          F is F1 + F2. % Alternatively plus(F1,F2,F)
        % Support negatives by adding following rule, and call it fib2
        % Remember: F(-n) = (-1)^(n+1) * F(n)
        fib2(F, N) :-
          AN is abs(N),                 % Find AN = abs(N)
          fib(PF, AN),                  % calculate F(abs(n)) as PF
          F is PF * (sign(N) ** (N+1)). % Use sign predicate to determine 1 or -1 from N
                                        %  and then raise to (N+1)

        % Factorial
        factorial(1, 0).  % 0! = 1
        factorial(F, N) :-
          succ(N1, N),
          factorial(F1, N1),
          F is F1 * N.
        ```
    * A real-world community using Prolog. What problems are they solving with it today?
* Do:

    ```prolog
    % Reverse the elements of a list; note that reverse/2 is already taken
    revl([X], [X]).
    revl(R, [H|T]) :- revl(RT, T), append(RT, [H], R).

    % Find the smallest element of a list, tail-recursive; note that min_list/2 is already taken
    min(Min, X, Y) :- % finds the min of two values
      X < Y, Min is X;
      X >= Y, Min is Y.
    % Beware that min_list exists already
    minl(Min, [H|T]) :- minl(Min, T, H). % default min is head
    minl(Min, [], Min). % Base case is empty list, return calculated min
    minl(Min, [H|T], X) :- min(CurrMin, H, X), minl(Min, T, CurrMin).

    % Sort the emelents of a list.
    % Let's use selection sort since we've already built minl
    takeout(RetList, X, List) :- list(List), takeout(RetList, X, List, []).
    takeout(RetList, H, [H|T], Past) :- append(Past, T, RetList).
    takeout(RetList, X, [H|T], Past) :-
      append(Past, [H], P),
      takeout(RetList, X, T, P).

    sortl(Sorted, List) :- list(List), sortl(Sorted, List, []).
    sortl(Sorted, [], Sorted).
    sortl(Sorted, List, Partial) :-
      minl(Min, List),
      takeout(Rest, Min, List),
      append(Partial, [Min], NewList),
      sortl(Sorted, Rest, NewList).

    % sortl is O(n^2); it is also stable
    ```
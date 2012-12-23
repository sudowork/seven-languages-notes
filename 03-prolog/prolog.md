## Prolog

Prolog is a **declarative** language: a language where you don't specify the control flow, as opposed to **imperative** languages. Specifically, Prolog belongs to a subset of declarative languages call **logic** programming languages. Prolog bases its computations on programmer-provided facts and inferences; it then deduces the result.

So how do you write a Prolog program? You define a set of assertions, **facts**, and Prolog will tell you if they're true. Even more powerful, is that if you leave gaps in your assertions, sprinkled with a few **rule**s, you can then **query** prolog and it will fill in the gaps for you.

### Day 1: An Excellent Driver
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

### Day 1: Self-Study
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

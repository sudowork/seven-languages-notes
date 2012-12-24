# Prolog Self-Study

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

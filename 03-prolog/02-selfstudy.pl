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

% Reverse the elements of a list; note that reverse/2 is already taken
revl([X], [X]).
revl(R, [H|T]) :- revl(RT, T), append(RT, [H], R).

% Find the smallest element of a list, tail-recursive; note that min_list/2 is already taken
min(Min, X, Y) :- % finds the min of two values
  X < Y, Min is X;
  X >= Y, Min is Y.
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

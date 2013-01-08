%% Recursion
fib(1, N) :- N < 3.
fib(V, N) :- N > 2, fib(N - 2, V1), fib(N - 1, V2), V is V1 + V2.

%% Tail recursion
fibTail(B, N, _, B) :- N < 3.
fibTail(V, N, A, B) :- N > 2, Sum is A + B, fibTail(V, N - 1, B, Sum).
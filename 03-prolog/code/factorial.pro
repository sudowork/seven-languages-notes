%% Recursion
factorial(1, 0).
factorial(V, N) :- N > 0, N2 is N - 1, factorial(V2, N2), V is N * V2.

%% Tail Recursion
factorialTail(V, 0, V).
factorialTail(V, N, Init) :- N > 0, N2 is N - 1, Accum is N * Init, factorialTail(V, N2, Accum).
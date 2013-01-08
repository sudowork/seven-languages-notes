% Not tail-recursive count
% count(0, []). % base case
% count(Count, [Head|Tail]) :- count(TailCount, Tail), Count is TailCount + 1. % we recursively call count on the tail of the list, and add 1 each time

% Tail-recursive version of count
count(Count, List) :- count(Count, List, 0).  % Alias count/2 to count/3
count(Count, [], A) :- Count is A.
count(Count, [H|T], A) :- count(Count, T, A + 1).

sum(0, []).   % base case
sum(Sum, [Head|Tail]) :- sum(TailSum, Tail), Sum is TailSum + Head. % we use the same method here

% Let's include product for fun
product(1, []).
product(Product, [Head|Tail]) :- product(TailProd, Tail), Product is TailProd * Head.

average(Average, List) :- sum(Sum, List), count(Count, List), Average is Sum / Count. % we take the sum and count and then take the average


%% Sort the elements of a list.

%% Include small.pl
%% ['small'].
%% Include sort.pl
%% ['sort'].

%% Doesn't yet support duplicates
sortList([H], [H]).
sortList(L, [H2|T2]) :- smallest(L, H2), without(L, H2, L2), sortList(L2, T2).

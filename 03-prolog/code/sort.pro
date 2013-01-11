%% Sort the elements of a list.

%% Include small
%% ['small'].

without([], _, []).
without([H|T], H, T).
without([H|T], Item, [H|T2]) :- \+(H = Item), without(T, Item, T2).

%% Doesn't yet support duplicates
sortList([H], [H]).
sortList(L, [H2|T2]) :- smallest(L, H2), without(L, H2, L2), sortList(L2, T2).

without([], _, []).
without([H|T], H, T).
without([H|T], Item, [H|T2]) :- \+(H = Item), without(T, Item, T2).
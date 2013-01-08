reverseList([H], [H]).
reverseList([H|T], R) :- reverseList(T, T2), append(T2, [H], R).

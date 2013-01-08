%% Find the smallest element of a list.
smallest([H], H).
smallest([Head|Tail], Small) :- smallest(Tail, Small2), Small2 < Head, Small is Small2.
smallest([Head|Tail], Small) :- smallest(Tail, Small2), Head < Small2, Small is Head.
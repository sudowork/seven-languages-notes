%% Replace _ variable so they can be printed properly
replaceUnderscores([], []).
replaceUnderscores([H|L], [H2|L2]) :-
  (\+integer(H) -> H2 = (-) ; H2 = H),
  replaceUnderscores(L, L2).

%% Format output
formatSudoku([]).
formatSudoku(Puzzle) :- formatSudoku(0, Puzzle).

formatSudoku(0, S) :-
    write('┌───────┬───────┬───────┐'), nl,
    formatSudoku(1, S).
formatSudoku(4, S) :-
    write('│───────┼───────┼───────│'), nl,
    formatSudoku(5, S).
formatSudoku(8, S) :-
    write('│───────┼───────┼───────│'), nl,
    formatSudoku(9, S).
formatSudoku(12, _) :-
    write('└───────┴───────┴───────┘'), nl.
formatSudoku(N, [C1, C2, C3, C4, C5, C6, C7, C8, C9 | S]) :-
    \+ member(N, [0, 4, 8, 12]),
    format(
      '│ ~k ~k ~k │ ~k ~k ~k │ ~k ~k ~k │~n',
      [C1, C2, C3, C4, C5, C6, C7, C8, C9]
    ),
    succ(N, N1),
    formatSudoku(N1, S).

%% Validator for each list
valid([]).
valid([Head|Tail]) :-
  fd_all_different(Head),
  valid(Tail).

sudoku(Puzzle) :-

  write('Input:'), nl,
  replaceUnderscores(Puzzle, FormattedInput),
  formatSudoku(FormattedInput),

  Solution = Puzzle,
  Puzzle = [
    S11, S12, S13, S14, S15, S16, S17, S18, S19,
    S21, S22, S23, S24, S25, S26, S27, S28, S29,
    S31, S32, S33, S34, S35, S36, S37, S38, S39,
    S41, S42, S43, S44, S45, S46, S47, S48, S49,
    S51, S52, S53, S54, S55, S56, S57, S58, S59,
    S61, S62, S63, S64, S65, S66, S67, S68, S69,
    S71, S72, S73, S74, S75, S76, S77, S78, S79,
    S81, S82, S83, S84, S85, S86, S87, S88, S89,
    S91, S92, S93, S94, S95, S96, S97, S98, S99
  ],
  fd_domain(Solution, 1, 9),

  R1 = [S11, S12, S13, S14, S15, S16, S17, S18, S19],
  R2 = [S21, S22, S23, S24, S25, S26, S27, S28, S29],
  R3 = [S31, S32, S33, S34, S35, S36, S37, S38, S39],
  R4 = [S41, S42, S43, S44, S45, S46, S47, S48, S49],
  R5 = [S51, S52, S53, S54, S55, S56, S57, S58, S59],
  R6 = [S61, S62, S63, S64, S65, S66, S67, S68, S69],
  R7 = [S71, S72, S73, S74, S75, S76, S77, S78, S79],
  R8 = [S81, S82, S83, S84, S85, S86, S87, S88, S89],
  R9 = [S91, S92, S93, S94, S95, S96, S97, S98, S99],

  C1 = [S11, S21, S31, S41, S51, S61, S71, S81, S91],
  C2 = [S12, S22, S32, S42, S52, S62, S72, S82, S92],
  C3 = [S13, S23, S33, S43, S53, S63, S73, S83, S93],
  C4 = [S14, S24, S34, S44, S54, S64, S74, S84, S94],
  C5 = [S15, S25, S35, S45, S55, S65, S75, S85, S95],
  C6 = [S16, S26, S36, S46, S56, S66, S76, S86, S96],
  C7 = [S17, S27, S37, S47, S57, S67, S77, S87, S97],
  C8 = [S18, S28, S38, S48, S58, S68, S78, S88, S98],
  C9 = [S19, S29, S39, S49, S59, S69, S79, S89, S99],

  Sq1 = [S11, S12, S13, S21, S22, S23, S31, S32, S33],
  Sq2 = [S14, S15, S16, S24, S25, S26, S34, S35, S36],
  Sq3 = [S17, S18, S19, S27, S28, S29, S37, S38, S39],
  Sq4 = [S41, S42, S43, S51, S52, S53, S61, S62, S63],
  Sq5 = [S44, S45, S46, S54, S55, S56, S64, S65, S66],
  Sq6 = [S47, S48, S49, S57, S58, S59, S67, S68, S69],
  Sq7 = [S71, S72, S73, S81, S82, S83, S91, S92, S93],
  Sq8 = [S74, S75, S76, S84, S85, S86, S94, S95, S96],
  Sq9 = [S77, S78, S79, S87, S88, S89, S97, S98, S99],

  valid([
    R1, R2, R3, R4, R5, R6, R7, R8, R9,
    C1, C2, C3, C4, C5, C6, C7, C8, C9,
    Sq1, Sq2, Sq3, Sq4, Sq5, Sq6, Sq7, Sq8, Sq9
  ]),

  write('Solution:'), nl,
  formatSudoku(Solution),

  fail.
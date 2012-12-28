min := 1
max := 100

random := (Random value(max - min) + min) floor
stdin := File standardInput

lastGuess := nil
guess := 0
diff := 0

10 repeat(
  writeln("Guess a number between ", min, " and ", max)
  guess = stdin readLine asNumber
  diff = (guess - random) abs

  if(diff == 0) then(
    break;
  ) else(
    if(lastGuess) then(
      if (diff < lastGuess) then(
        "warmer" println
      ) else(
        "colder" println
      )
    )
    lastGuess = diff
  )
)

writeln("The number is ", random)
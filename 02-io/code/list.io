squareBrackets := method(
  list() appendSeq(call message arguments)
)

s := File with("list.txt") openForReading contents
l := doString(s)
l println
l size println
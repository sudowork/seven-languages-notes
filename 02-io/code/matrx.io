Matrix := List clone

Matrix dim := method(x, y,
  matrix := Matrix clone;
  for(i, 1, y, matrix append(list() setSize(x)));
  matrix
)

Matrix row := method(self size)
Matrix column := method(if(self first == nil, 0, self first size))

Matrix set := method(x, y, value,
  self at(y) atPut(x, value);
  self
)

Matrix get := method(x, y, value,
  self at(y) at(x)
)

Matrix transpose := method(
  row := self row
  column := self column

  tmatrix := Matrix dim(column, row)

  for(i, 0, column - 1,
    for(j, 0, row - 1,
      tmatrix set(i, j, self get(j, i))
    )
  )

  tmatrix
)

Matrix saveToFile := method(filename,
  f := File with(filename)
  f remove
  f openForUpdating
  f write(
    self map(row, row join(",")) join("\n")
  )
  f close
);

Matrix readFromFile := method(filename,
  matrix := Matrix clone;
  f := File with(filename)
  f openForReading
  f readLines foreach(i, row, matrix append(row split(",")))
  f close
  matrix
);

nm := Matrix clone

m := Matrix dim(2, 2) set(0, 0, 1) set(0, 1, 2) set(1, 0, 3) set(1, 1, 4)
m println
tm := m transpose
tm println
(tm get(0, 1) == m get(1, 0)) println

m saveToFile("matrix.data")
m readFromFile("matrix.data") println
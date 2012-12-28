List myAverage := method(
  if(self size == 0) then(return nil);
  foreach(i, item,
    if(item type != "Number")
    then(
      Exception raise(list("list[", i, "]:", item, "is not a number") join(" "))
    )
  );
  self average
)

list() myAverage
list(1, 2, 3) myAverage
list(1, 2, 3, "a") myAverage
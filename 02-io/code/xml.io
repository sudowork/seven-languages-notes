OperatorTable addAssignOperator(":", "atPutNumber")
curlyBrackets := method(
  r := Map clone
  call message arguments foreach(arg,
    r doMessage(arg)
  )
  r
)

Map atPutNumber := method(
  self atPut(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
    call evalArgAt(1)
  )
)

Builder := Object clone

indentation := "\t"
Builder prefix := "" asMutable
Builder indent := method(
  self prefix appendSeq(indentation)
)
Builder unindent := method(
  self prefix removeSuffix(indentation)
)
Builder writeIndent := method(
  write(self prefix)
)
Builder writeln := method(
  args := call message argsEvaluatedIn(call sender)
  writeln(self prefix, args join(""))
)

Builder forward := method(
  args := call message arguments
  if (args first and args first name == "curlyBrackets") then(
    m := doString(args first asString)
    self writeIndent
    write("<", call message name);
    m foreach(key, value,
      write(" ",key, "=\"", value, "\"")
    )
    writeln(">");
    args = args rest
  ) else (
    self writeln("<", call message name, ">");
  )
  self indent
  args foreach(arg,
    content := self doMessage(arg);
    if(content type == "Sequence", self writeln(content))
  );
  self unindent
  self writeln("</", call message name, ">")
)

Builder div(
  {
    "class": "container",
    "id": "top_container"
  },
  h3({ "class": "header" },"Io is awesome"),
  div(
    h5("Prototype Languages"),
    ul(
      { "class": "list" },
      li("Io"),
      li("Lua"),
      li("JavaScript")
    )
  )
)
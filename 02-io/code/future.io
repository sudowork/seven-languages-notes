futureResult := URL with("http://google.com/") @fetch
writeln("Do something immediately while fetch goes on in background...")
# blocks until future returns
writeln("fetched ", futureResult size, " bytes")
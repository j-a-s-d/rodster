# rodster
##
# ARGUMENTS EXAMPLE

## This example helps to understand how to use the application arguments services.

## Just compile and run this with: nim c -r arguments.nim -numbers:1,2,3 -help --n:4,5,6

import rodster, xam

let app = newRodsterApplication("arguments test app", "1.0.0")
app.setInitializationHandler proc (app: RodsterApplication) =
  let nfo = app.getInformation()
  echo "arguments count: " & $nfo.getArguments().len
  echo "arguments received: " & $nfo.getArguments()
  echo "argument 'help' received: " & $nfo.hasArgument("-help")
app.setMainRoutine proc (app: RodsterApplication) =
  let nfo = app.getInformation()
  let idxs = nfo.findArgumentsWithPrefix(["--n:", "-numbers:"])
  echo "argument 'numbers' received at argument indexes: " & $idxs
  idxs.each idx:
    echo spaced("value received at index", $idx & ":", $nfo.getArgumentWithoutPrefix(idx, ["--n:", "-numbers:"]))
app.run()

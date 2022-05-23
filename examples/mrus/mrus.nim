# rodster
##
# MRUS EXAMPLE

## This example helps to understand how to use the application most recently used list.

import rodster, xam

let app = newRodsterApplication("mrus test app", "1.0.0")
app.setInitializationHandler proc (app: RodsterApplication) =
  let mru = app.getMru()
  mru.setMaximum(3) # max by default is 10
  mru.add("http://www.apple.com")
  mru.add("http://www.google.com")
  mru.add("http://www.microsoft.com")
app.setMainRoutine proc (app: RodsterApplication) =
  let mru = app.getMru()
  echo "the app has the following mrus: " & $mru.getAsStringSeq()
  echo "but adding a new one, makes the oldest to drop..."
  mru.add("http://www.github.com")
  echo "so now the app has the following mrus: " & $mru.getAsStringSeq()
app.run()

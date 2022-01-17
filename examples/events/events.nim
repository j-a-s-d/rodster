# rodster
##
# EVENTS EXAMPLE

## This example helps to understand the application events definition.

import rodster

let events: RodsterAppEvents = (
  initializer: RodsterAppEvent(proc (app: RodsterApplication) = stdout.write "hello"),
  main: RodsterAppEvent(proc (app: RodsterApplication) = stdout.write " world"),
  finalizer: RodsterAppEvent(proc (app: RodsterApplication) = echo "!")
)

run newRodsterApplication("Rodster Events Example", "1.0.0", events)


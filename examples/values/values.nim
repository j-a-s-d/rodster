# rodster
##
# VALUES EXAMPLE

## This example helps to understand how to use the application integrated multipurpose key-value store.

import rodster, xam

let app = newRodsterApplication()
app.getInformation().setTitle("values test app")
app.getInformation().setVersion("1.0.0")
app.setInitializationHandler proc (app: RodsterApplication) =
  app.getKvm().setKey("some-key", "some-value")
app.setMainRoutine proc (app: RodsterApplication) =
  echo "the app has the key 'some-key' with a value of: " & app.getKvm().getKey("some-key")
app.setFinalizationHandler proc (app: RodsterApplication) =
  app.getKvm().dropKey("some-key")
app.run()

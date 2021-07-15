# rodster
##
# VALUES EXAMPLE

## This example helps to understand how to use the application integrated multipurpose key-value store.

import rodster, xam

let app = newRodsterApplication("values test app", "1.0.0")
app.setInitializationHandler proc (app: RodsterApplication) =
  let kvm = app.getKvm()
  kvm.setKey("some-key", "some-value")
  kvm["other-key"] = "other-value"
app.setMainRoutine proc (app: RodsterApplication) =
  let kvm = app.getKvm()
  echo "the app has the key 'some-key' with a value of: " & kvm.getKey("some-key")
  echo "and also the key 'other-key' with a value of: " & kvm["other-key"]
app.setFinalizationHandler proc (app: RodsterApplication) =
  app.getKvm().dropKey("some-key")
app.run()

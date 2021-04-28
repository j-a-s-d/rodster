# rodster
##
# CONFIG EXAMPLE

## This example helps to understand how to use the application settings.

import rodster, xam, json

proc onInitialize(app: RodsterApplication) =
  let sets = app.getSettings()
  if sets.loadFromFile("config.json"):
    echo "loaded preferences for version " & sets.getAsString("version") & "!"
  else:
    echo "failed to load preferences"

proc programRun(app: RodsterApplication) =
  if app.getSettings.getAsString("version") == $app.getInformation().getVersion():
    echo "good settings :)"
  else:
    echo "bad settings :("

proc onFinalize(app: RodsterApplication) =
  echo "bye! " & parenthesize app.getSettings.getAsString("version")

let app = newRodsterApplication()
app.getInformation().setTitle("config test app")
app.getInformation().setVersion("1.0.0")
app.getSettings().getModel().loadFromJArray(%* ["mandatory string version"])
app.setInitializationHandler(onInitialize)
app.setMainRoutine(programRun)
app.setFinalizationHandler(onFinalize)
app.run()

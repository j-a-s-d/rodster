# rodster
##
# INFO EXAMPLE

## This example helps to understand how to use the application information.

import rodster, xam

proc onInitialize(app: RodsterApplication) =
  echo "loading " & app.getInformation().getTitle() & " " & $app.getInformation().getVersion() & " ..."

proc programRun(app: RodsterApplication) =
  let nfo = app.getInformation()
  echo "the app filename is: " & nfo.getFilename()
  echo "the app directory is: " & nfo.getDirectory()
  echo "the app pid is: " & nfo.getProcessId()
  echo "the app unique instance id is: " & nfo.getInstanceId()
  echo "the app existing time (in seconds) is: " & nfo.getElapsedSecondsSinceCreationAsString()

proc onFinalize(app: RodsterApplication) =
  echo "bye!"

let app = newRodsterApplication()
app.getInformation().setTitle("info test app")
app.getInformation().setVersion("1.0.0")
app.setInitializationHandler(onInitialize)
app.setMainRoutine(programRun)
app.setFinalizationHandler(onFinalize)
app.run()

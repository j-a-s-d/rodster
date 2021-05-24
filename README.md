# rodster
an application framework for nim

## FEATURES

* inverse-of-control (IoC), *allowing separation-of-concerns (SoC) between application initialization/finalization and the main program routine*
* self-exception handling (SEH), *allowing secure execution and extended control on program flow*
* modelled json settings, *allowing an easy, secure and structured way to validate and handle the application configuration*
* internationalization support (I18n), *allowing localization (L10n) for the application messages*
* multipurpose key value map, *allowing an easy application instance values management in an already integrated key-value store*

## CHARACTERISTICS

* no external dependencies (just nim and xam)
* self-documenting api (descriptive long proc names)
* full unit testing
* markdown documentation (TODO)

## EXAMPLES

### HELLO WORLD

This example helps to understand the application IoC flow.

```nim

import rodster

let app = newRodsterApplication()
app.setInitializationHandler proc (app: RodsterApplication) = stdout.write "hello"
app.setMainRoutine proc (app: RodsterApplication) = stdout.write " world"
app.setFinalizationHandler proc (app: RodsterApplication) = echo "!"
app.run()

```

### INFO

This example helps to understand how to use the application information.

```nim

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

```

### CONFIG

This example helps to understand how to use the application settings.

```nim

import rodster, xam, json

proc onInitialize(app: RodsterApplication) =
  let sets = app.getSettings()
  if sets.loadFromFile("config.json"):
    echo "loaded preferences for version " & sets.getAsString("version") & "!"
  else:
    echo "failed to load preferences"

proc programRun(app: RodsterApplication) =
  if app.getSettings().getAsString("version") == $app.getInformation().getVersion():
    echo "good settings :)"
  else:
    echo "bad settings :("

proc onFinalize(app: RodsterApplication) =
  echo "bye! " & parenthesize app.getSettings().getAsString("version")

let app = newRodsterApplication()
app.getInformation().setTitle("config test app")
app.getInformation().setVersion("1.0.0")
app.getSettings().getModel().loadFromJArray(%* ["mandatory string version"])
app.setInitializationHandler(onInitialize)
app.setMainRoutine(programRun)
app.setFinalizationHandler(onFinalize)
app.run()

```

### LOCALIZATION

This example helps to understand how to use the application localization.

```nim

import rodster, xam

proc loadLocalizedMessages(i18n: RodsterAppI18n, locale: string) =
  echo "loading " & locale & " messages ..."
  if not i18n.loadTextsFromFile(locale, locale & ".json"):
    die "ERROR"

proc onInitialize(app: RodsterApplication) =
  let i18n = app.getI18n()
  loadLocalizedMessages(i18n, "EN")
  loadLocalizedMessages(i18n, "ES")
  loadLocalizedMessages(i18n, "PT")
  loadLocalizedMessages(i18n, "FR")
  loadLocalizedMessages(i18n, "IT")
  loadLocalizedMessages(i18n, "DE")

proc programRun(app: RodsterApplication) =
  let i18n = app.getI18n()
  # example using current locale
  echo "[EN] " & i18n.getText("strings.hello", @["World"])
  # examples changing the current locale
  i18n.setCurrentLocale("ES")
  echo "[ES] " & i18n.getText("strings.hello", @["Mundo"])
  i18n.setCurrentLocale("PT")
  echo "[PT] " & i18n.getText("strings.hello", @["Mundo"])
  # examples without using the current locale
  echo "[FR] " & i18n.getText("FR", "strings.hello", @["Monde"])
  echo "[IT] " & i18n.getText("IT", "strings.hello", @["Mondo"])
  echo "[DE] " & i18n.getText("DE", "strings.hello", @["Welt"])

proc onFinalize(app: RodsterApplication) =
  # example without values to be replaced and that will resort back to the default locale to be loaded
  echo app.getI18n().getText("strings.bye")

let app = newRodsterApplication()
app.getInformation().setTitle("localization test app")
app.getInformation().setVersion("1.0.0")
app.setInitializationHandler(onInitialize)
app.setMainRoutine(programRun)
app.setFinalizationHandler(onFinalize)
app.run()

```

### VALUES

This example helps to understand how to use the application integrated multipurpose key-value store.

```nim

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

```

## HISTORY
* 24-05-21 *[0.2.1]*
	- addded multipurpose key value map module
* 23-05-21 *[0.2.0]*
	- added localization example
	- added internationalization module
	- updated xam dependency
* 28-04-21 *[0.1.2]*
	- added RodsterApplication.isRunning()
	- added config example
* 23-04-21 *[0.1.1]*
	- added info example
	- added documentation comments
* 20-04-21 *[0.1.0]*
	- first release
* 14-04-21 *[0.0.1]*
	- started coding

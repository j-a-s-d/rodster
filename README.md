# rodster
an application framework for nim

## FEATURES

* inverse-of-control (IoC), *allowing separation-of-concerns (SoC) between application initialization/finalization and the main program routine*
* self-exception handling (SEH), *allowing secure execution and extended control on program flow*
* modelled json settings, *allowing an easy, secure and structured way to validate and handle the application configuration*
* internationalization support (I18n), *allowing localization (L10n) for the application messages*
* multipurpose key value map, *allowing an easy application instance values management in an already integrated key-value store*
* arguments handling services, *allowing a good handling of the parameters that the app received*
* most recently used items list, *allowing bring this feature up to your end users without effort*

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
  echo "[EN] " & i18n.getText("strings.hello", ["World"])
  # examples changing the current locale
  i18n.setCurrentLocale("ES")
  echo "[ES] " & i18n.getText("strings.hello", ["Mundo"])
  i18n.setCurrentLocale("PT")
  echo "[PT] " & i18n.getText("strings.hello", ["Mundo"])
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

```

### EVENTS

This example helps to understand the application events definition.

```nim

import rodster

let events: RodsterAppEvents = (
  initializer: RodsterAppEvent(proc (app: RodsterApplication) = stdout.write "hello"),
  main: RodsterAppEvent(proc (app: RodsterApplication) = stdout.write " world"),
  finalizer: RodsterAppEvent(proc (app: RodsterApplication) = echo "!")
)

run newRodsterApplication("Rodster Events Example", "1.0.0", events)

```

### ARGUMENTS

This example helps to understand how to use the application arguments services.

``` nim

## Just compile and run this with: nim c -r arguments.nim -numbers:1,2,3 -help --n:4,5,6

import rodster, xam

let app = newRodsterApplication("arguments test app", "1.0.0")
app.setInitializationHandler proc (app: RodsterApplication) =
  let nfo = app.getInformation()
  echo "has arguments: " & $nfo.hasArguments()
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

```

### MRUS

This example helps to understand how to use the application's most recently used items list.

``` nim

## Just compile and run this with: nim c -r mrus.nim

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

```

## HISTORY
* 23-05-22 *[1.4.0]*
	- added mru module
	- added mrus example
	- updated xam dependency
* 19-05-22 *[1.3.1]*
	- added hasArguments to the info module
	- improved i18n getText implementation
	- updated xam dependency
* 28-01-22 *[1.3.0]*
	- added getArguments, hasArgument, findArgumentsWithPrefix and getArgumentWithoutPrefix to the info module
	- added arguments example
* 17-01-22 *[1.2.0]*
	- added constructor argument to accept app events
	- added events example
	- updated xam dependency
* 03-01-22 *[1.1.0]*
	- added app events getter and setter
	- added individual app events getters
	- updated xam dependency
* 15-07-21 *[1.0.0]*
	- added app constructor overload accepting title and version
	- added kvm getter and setter array access operators
	- updated xam dependency
* 25-05-21 *[0.3.0]*
	- added RodsterApplication.terminate() and RodsterApplication.wasTerminated()
* 24-05-21 *[0.2.1]*
	- added multipurpose key value map module
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

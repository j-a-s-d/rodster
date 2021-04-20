# rodster
an application framework for nim

## FEATURES

* inverse-of-control (IoC), *allowing separation-of-concerns (SoC) between application initialization/finalization and the main program routine*
* self-exception handling (SEH), *allowing secure execution and extended control on program flow*
* modelled json settings, *allowing an easy, secure and structured way to validate and handle the application configuration*

## CHARACTERISTICS

* no external dependencies (just nim and xam)
* self-documenting api (descriptive long proc names)
* full unit testing
* markdown documentation (TODO)

## EXAMPLE:

```nim

import rodster

let app = newRodsterApplication()
app.setInitializationHandler proc (app: RodsterApplication) = stdout.write "hello"
app.setMainRoutine proc (app: RodsterApplication) = stdout.write " main"
app.setFinalizationHandler proc (app: RodsterApplication) = echo "!"
app.run()

```

## HISTORY
* 20-04-21 *[0.1.0]*
	- first release
* 14-04-21 *[0.0.1]*
	- started coding

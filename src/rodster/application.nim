# rodster
##
# APPLICATION

import xam

reexport(information, information)
reexport(settings, settings)
reexport(seh, seh)
reexport(i18n, i18n)
reexport(kvm, kvm)
reexport(mru, mru)

type
  TRodsterAppStep = enum
    raStopped,
    raInitializing,
    raRunning,
    raFinalizing
  TRodsterAppTerminated = object of CatchableError
  TRodsterApplication = object
    terminated: bool
    step: TRodsterAppStep
    events: RodsterAppEvents
    information: RodsterAppInformation
    settings: RodsterAppSettings
    seh: RodsterAppSeh
    i18n: RodsterAppI18n
    kvm: RodsterAppKvm
    mru: RodsterAppMru
  RodsterApplication* = ref TRodsterApplication
  RodsterAppEvent* = proc (app: RodsterApplication)
  RodsterAppEvents* = tuple
    initializer: RodsterAppEvent
    main: RodsterAppEvent
    finalizer: RodsterAppEvent

let
  DEFAULT_APPEVENT_HANDLER*: RodsterAppEvent = func (app: RodsterApplication) = discard
  DEFAULT_APPEVENTS*: RodsterAppEvents = (
    initializer: DEFAULT_APPEVENT_HANDLER,
    main: DEFAULT_APPEVENT_HANDLER,
    finalizer: DEFAULT_APPEVENT_HANDLER
  )

template launchAppEvent(app: RodsterApplication, appEventHandler: RodsterAppEvent) =
  ensure(appEventHandler, DEFAULT_APPEVENT_HANDLER)(app)

func wasTerminated*(app: RodsterApplication): bool =
  ## Returns true if the application was user terminated in the last run or false otherwise.
  app.terminated

func isRunning*(app: RodsterApplication): bool =
  ## Determines if the application is running.
  app.step != raStopped

func getInformation*(app: RodsterApplication): RodsterAppInformation =
  ## Gets the information object instance.
  app.information

func getSettings*(app: RodsterApplication): RodsterAppSettings =
  ## Gets the settings object instance.
  app.settings

func getSeh*(app: RodsterApplication): RodsterAppSeh =
  ## Gets the seh object instance.
  app.seh

func getI18n*(app: RodsterApplication): RodsterAppI18n =
  ## Gets the i18n object instance.
  app.i18n

func getKvm*(app: RodsterApplication): RodsterAppKvm =
  ## Gets the kvm object instance.
  app.kvm

func getMru*(app: RodsterApplication): RodsterAppMru =
  ## Gets the mru object instance.
  app.mru

func getEvents*(app: RodsterApplication): RodsterAppEvents =
  ## Gets the app events.
  app.events

func setEvents*(app: RodsterApplication, events: RodsterAppEvents) =
  ## Sets the app events all at once.
  app.events = events

func getInitializationHandler*(app: RodsterApplication): RodsterAppEvent =
  ## Gets the initialization handler.
  app.events.initializer

func setInitializationHandler*(app: RodsterApplication, onInitialize: RodsterAppEvent) =
  ## Sets the initialization handler.
  app.events.initializer = onInitialize

func getMainRoutine*(app: RodsterApplication): RodsterAppEvent =
  ## Gets the main routine.
  app.events.main

func setMainRoutine*(app: RodsterApplication, programMain: RodsterAppEvent) =
  ## Sets the main routine.
  app.events.main = programMain

func getFinalizationHandler*(app: RodsterApplication): RodsterAppEvent =
  ## Gets the finalization handler.
  app.events.finalizer

func setFinalizationHandler*(app: RodsterApplication, onFinalize: RodsterAppEvent) =
  ## Sets the finalization handler.
  app.events.finalizer = onFinalize

proc performStep(app: RodsterApplication, step: TRodsterAppStep, procedure: NoArgsVoidProc): bool =
  app.step = step
  var e: ref Exception
  catch(procedure, e)
  result = e == nil
  if not result:
    app.terminated = e.name == "TRodsterAppTerminated"
    if not app.terminated:
      app.seh.setLastException(e)

proc run*(app: RodsterApplication) =
  ## Runs the application.
  app.terminated = false
  app.seh.forgetLastException()
  if app.performStep(raInitializing, () => app.launchAppEvent(app.getInitializationHandler())):
    if app.performStep(raRunning, () => app.launchAppEvent(app.getMainRoutine())):
      discard app.performStep(raFinalizing, () => app.launchAppEvent(app.getFinalizationHandler()))
  app.step = raStopped

proc terminate*(app: RodsterApplication) =
  ## Terminates the application.
  ## NOTE: it will run the finalizer if invoked in initialization or running steps.
  if app.step == raInitializing or app.step == raRunning:
    discard app.performStep(raFinalizing, () => app.launchAppEvent(app.getFinalizationHandler()))
    throw(TRodsterAppTerminated, STRINGS_EMPTY)

proc newRodsterApplication*(title: string = STRINGS_EMPTY, version: string = STRINGS_EMPTY, events: RodsterAppEvents = DEFAULT_APPEVENTS): RodsterApplication =
  ## Constructs a new application object instance.
  result = new TRodsterApplication
  result.terminated = false
  result.step = raStopped
  result.events = events
  result.information = newRodsterAppInformation()
  if hasText(title):
    result.information.setTitle(title)
  if hasText(version):
    result.information.setVersion(version)
  result.settings = newRodsterAppSettings()
  result.seh = newRodsterAppSeh()
  result.i18n = newRodsterAppI18n()
  result.kvm = newRodsterAppKvm()
  result.mru = newRodsterAppMru()

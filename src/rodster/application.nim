# rodster
##
# APPLICATION

import xam

reexport(information, information)
reexport(settings, settings)
reexport(seh, seh)
reexport(i18n, i18n)
reexport(kvm, kvm)

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
  RodsterApplication* = ref TRodsterApplication
  RodsterAppEvent* = proc (app: RodsterApplication)
  RodsterAppEvents* = tuple [
    initializer: RodsterAppEvent,
    main: RodsterAppEvent,
    finalizer: RodsterAppEvent
  ]

let
  DEFAULT_APPEVENT_HANDLER: RodsterAppEvent = proc (app: RodsterApplication) = discard

proc wasTerminated*(app: RodsterApplication): bool =
  ## Returns true if the application was user terminated in the last run or false otherwise.
  app.terminated

proc isRunning*(app: RodsterApplication): bool =
  ## Determines if the application is running.
  app.step != raStopped

proc getInformation*(app: RodsterApplication): RodsterAppInformation =
  ## Gets the information object instance.
  app.information

proc getSettings*(app: RodsterApplication): RodsterAppSettings =
  ## Gets the settings object instance.
  app.settings

proc getSeh*(app: RodsterApplication): RodsterAppSeh =
  ## Gets the seh object instance.
  app.seh

proc getI18n*(app: RodsterApplication): RodsterAppI18n =
  ## Gets the i18n object instance.
  app.i18n

proc getKvm*(app: RodsterApplication): RodsterAppKvm =
  ## Gets the kvm object instance.
  app.kvm

proc setInitializationHandler*(app: RodsterApplication, onInitialize: RodsterAppEvent) =
  ## Set the initialization handler.
  app.events.initializer = onInitialize

proc setMainRoutine*(app: RodsterApplication, programMain: RodsterAppEvent) =
  ## Sets the main routine.
  app.events.main = programMain

proc setFinalizationHandler*(app: RodsterApplication, onFinalize: RodsterAppEvent) =
  ## Sets the finalization handler.
  app.events.finalizer = onFinalize

proc performStep(app: RodsterApplication, step: TRodsterAppStep, procedure: NoArgsProc[void]): bool =
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
  if app.performStep(raInitializing, () => app.events.initializer(app)):
    if app.performStep(raRunning, () => app.events.main(app)):
      discard app.performStep(raFinalizing, () => app.events.finalizer(app))
  app.step = raStopped

proc terminate*(app: RodsterApplication) =
  ## Terminates the application.
  ## NOTE: it will run the finalizer if invoked in initialization or running steps.
  if app.step == raInitializing or app.step == raRunning:
    discard app.performStep(raFinalizing, () => app.events.finalizer(app))
    throw(TRodsterAppTerminated, STRINGS_EMPTY)

proc newRodsterApplication*(title: string = "", version: string = ""): RodsterApplication =
  ## Constructs a new application object instance.
  result = new TRodsterApplication
  result.terminated = false
  result.step = raStopped
  result.events = (
    initializer: DEFAULT_APPEVENT_HANDLER,
    main: DEFAULT_APPEVENT_HANDLER,
    finalizer: DEFAULT_APPEVENT_HANDLER
  )
  result.information = newRodsterAppInformation()
  if hasText(title):
    result.information.setTitle(title)
  if hasText(version):
    result.information.setVersion(version)
  result.settings = newRodsterAppSettings()
  result.seh = newRodsterAppSeh()
  result.i18n = newRodsterAppI18n()
  result.kvm = newRodsterAppKvm()

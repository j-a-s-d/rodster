# rodster
##
# APPLICATION

import xam

reexport(information, information)
reexport(settings, settings)
reexport(seh, seh)
reexport(i18n, i18n)

type
  TRodsterAppStep = enum
    raStopped,
    raInitializing,
    raRunning,
    raFinalizing
  TRodsterApplication = object
    step: TRodsterAppStep
    events: RodsterAppEvents
    information: RodsterAppInformation
    settings: RodsterAppSettings
    seh: RodsterAppSeh
    i18n: RodsterAppI18n
  RodsterApplication* = ref TRodsterApplication
  RodsterAppEvent* = proc (app: RodsterApplication)
  RodsterAppEvents* = tuple [
    initializer: RodsterAppEvent,
    main: RodsterAppEvent,
    finalizer: RodsterAppEvent
  ]

let
  DEFAULT_APPEVENT_HANDLER: RodsterAppEvent = proc (app: RodsterApplication) = discard

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
    app.seh.setLastException(e)

proc run*(app: RodsterApplication) =
  ## Runs the application.
  app.seh.forgetLastException()
  if app.performStep(raInitializing, () => app.events.initializer(app)):
    if app.performStep(raRunning, () => app.events.main(app)):
      discard app.performStep(raFinalizing, () => app.events.finalizer(app))
  app.step = raStopped

proc newRodsterApplication*(): RodsterApplication =
  ## Constructs a new application object instance.
  result = new TRodsterApplication
  result.step = raStopped
  result.events = (
    initializer: DEFAULT_APPEVENT_HANDLER,
    main: DEFAULT_APPEVENT_HANDLER,
    finalizer: DEFAULT_APPEVENT_HANDLER
  )
  result.information = newRodsterAppInformation()
  result.settings = newRodsterAppSettings()
  result.seh = newRodsterAppSeh()
  result.i18n = newRodsterAppI18n()

# rodster
##
# APPLICATION

import xam

reexport(information, information)
reexport(settings, settings)
reexport(seh, seh)

type
  TRodsterApplication = object
    events: RodsterAppEvents
    information: RodsterAppInformation
    settings: RodsterAppSettings
    seh: RodsterAppSeh
  RodsterApplication* = ref TRodsterApplication
  RodsterAppEvent* = proc (app: RodsterApplication)
  RodsterAppEvents* = tuple [
    initializer: RodsterAppEvent,
    main: RodsterAppEvent,
    finalizer: RodsterAppEvent
  ]

let
  DEFAULT_APPEVENT_HANDLER: RodsterAppEvent = proc (app: RodsterApplication) = discard

proc newRodsterApplication*(): RodsterApplication =
  result = new TRodsterApplication
  result.events = (
    initializer: DEFAULT_APPEVENT_HANDLER,
    main: DEFAULT_APPEVENT_HANDLER,
    finalizer: DEFAULT_APPEVENT_HANDLER
  )
  result.information = newRodsterAppInformation()
  result.settings = newRodsterAppSettings()
  result.seh = newRodsterAppSeh()

proc getInformation*(app: RodsterApplication): RodsterAppInformation =
  app.information

proc getSettings*(app: RodsterApplication): RodsterAppSettings =
  app.settings

proc getSeh*(app: RodsterApplication): RodsterAppSeh =
  app.seh

proc setInitializationHandler*(app: RodsterApplication, onInitialize: RodsterAppEvent) =
  app.events.initializer = onInitialize

proc setMainRoutine*(app: RodsterApplication, programMain: RodsterAppEvent) =
  app.events.main = programMain

proc setFinalizationHandler*(app: RodsterApplication, onFinalize: RodsterAppEvent) =
  app.events.finalizer = onFinalize

proc step(app: RodsterApplication, procedure: NoArgsProc[void]): bool =
  var e: ref Exception
  catch(procedure, e)
  result = e == nil
  if not result:
    app.seh.setLastException(e)

proc run*(app: RodsterApplication) =
  app.seh.forgetLastException()
  if app.step(() => app.events.initializer(app)):
    if app.step(() => app.events.main(app)):
      discard app.step(() => app.events.finalizer(app))

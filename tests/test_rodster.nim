# rodster by Javier Santo Domingo (j-a-s-d@coderesearchlabs.com)

import
  unittest, os, json, xam, rodster

suite "test rodster":

  let cfg1 = parseJson("""
    { "i": 123, "b": true, "f": 123.45, "s": "hello", "a": [1, 2, 3] }
  """)
  let cfg2 = parseJson("""
    { "i": 456, "b": false, "f": 456.78, "s": "world", "a": [4, 5, 6] }
  """)
  let msg1 = parseJson("""[
    { "code": "strings.hey", "message": "hello" },
    { "code": "strings.blah", "message": "blah1 $1 $2 blah4" }
  ]""")
  let msg2 = parseJson("""[
    { "code": "strings.hey", "message": "hola" }
  ]""")
  let app = newRodsterApplication()

  const
    APP_TITLE = "Title"
    APP_VERSION = "1.0.0"
    CFG_FILE = "test.json"

  test "test app":
    check(app != nil)

  test "test info":
    let info = app.getInformation()
    check(info != nil)
    info.setTitle(APP_TITLE)
    check(info.getTitle() == APP_TITLE)
    info.setVersion(APP_VERSION)
    check($info.getVersion() == APP_VERSION)
    check(info.getFilename() != STRINGS_EMPTY)
    check(info.getDirectory() != STRINGS_EMPTY)
    check(info.getProcessId() != STRINGS_EMPTY)
    check(info.getInstanceId() != STRINGS_EMPTY)
    nap(1000)
    check(info.getElapsedSecondsSinceCreation() > 0)
    check(info.getElapsedSecondsSinceCreationAsString() != "0s")
    check(info.getElapsedMinutesSinceCreation() == 0)
    check(info.getElapsedMinutesSinceCreationAsString() == "0m")
    check(not info.hasArguments())
    check(info.getArguments() == newStringSeq())
    check(not info.hasArgument("test"))
    check(info.findArgumentsWithPrefix(["--t", "-test"]) == newIntSeq())
    check(info.getArgumentWithoutPrefix(0, ["--t", "-test"]) == STRINGS_EMPTY)
    check(info.getArgumentWithoutPrefix(-1, ["--t", "-test"]) == STRINGS_EMPTY)

  test "test settings":
    let sets = app.getSettings()
    check(sets != nil)
    check(sets.getFilename() == STRINGS_EMPTY)
    sets.getModel().defineMandatoryInteger("i").defineMandatoryString("s").defineMandatoryBoolean("b").defineMandatoryFloat("f").registerOptionalArray("a")
    check(sets.getModel().len == 5)
    check(sets.loadFromJObject(cfg1))
    check(sets.getAsInteger("i") == 123)
    check(sets.getAsInteger("blah") == 0)
    check(sets.getAsInteger("blah", 789) == 789)
    check(sets.getAsFloat("f") == 123.45)
    check(sets.getAsFloat("blah") == 0.0)
    check(sets.getAsFloat("blah", 78.9) == 78.9)
    check(sets.reload())
    check(sets.getAsBoolean("b") == true)
    check(sets.getAsBoolean("blah") == false)
    check(sets.getAsBoolean("blah", true) == true)
    check(sets.getAsString("s") == "hello")
    check(sets.getAsString("blah") == "")
    check(sets.getAsString("blah", "default") == "default")
    check(sets.has("a"))
    check(sets.getAsJsonNode("a").kind == JArray)
    check(sets.getAsJsonNode("nnn").kind == JNull)
    check(sets.getAsJsonNode("nnn", JSON_TRUE).kind == JBool)
    check(saveJsonNodeToFile(CFG_FILE, cfg2))
    check(sets.loadFromFile(CFG_FILE))
    check(sets.getAsInteger("i") == 456)
    check(sets.getAsFloat("f") == 456.78)
    check(sets.reload())
    check(sets.getAsBoolean("b") == false)
    check(sets.getAsString("s") == "world")
    removeFile(CFG_FILE)

  test "test i18n":
    let i18n = app.getI18n()
    check(i18n != nil)
    check(i18n.getCurrentLocale() == STRINGS_EMPTY)
    check(i18n.getText("strings.hey") == STRINGS_EMPTY)
    check(i18n.loadTextsFromJArray("EN", msg1))
    check(i18n.getCurrentLocale() == "EN")
    check(i18n.loadTextsFromJArray("ES", msg2))
    check(i18n.getCurrentLocale() == "EN")
    check(i18n.getText("strings.hey") == "hello")
    check(i18n.getText("strings.hey", @[]) == "hello")
    check(i18n.getText("strings.hey", []) == "hello")
    check(i18n.getText("strings.hey", @["world"]) == "hello")
    check(i18n.getText("strings.hey", ["world"]) == "hello")
    i18n.setCurrentLocale("ES")
    check(i18n.getCurrentLocale() == "ES")
    check(i18n.getText("strings.hey") == "hola")
    i18n.setCurrentLocale("PT")
    check(i18n.getText("strings.hey") == "hello")
    i18n.setCurrentLocale("EN")
    check(i18n.getText("strings.blah", @["blah2", "blah3"]) == "blah1 blah2 blah3 blah4")
    check(i18n.getText("strings.blah", ["blah2", "blah3", "blah5"]) == "blah1 blah2 blah3 blah4")
    check(i18n.getText("strings.blah", @["blah2"]) == "blah1 $1 $2 blah4")
    check(i18n.getText("strings.blah", @[]) == "blah1 $1 $2 blah4")
    check(i18n.getText("strings.blah") == "blah1 $1 $2 blah4")

  test "test kvm":
    let kvm = app.getKvm()
    check(kvm != nil)
    check(kvm.len == 0)
    check(not kvm.hasKey("test"))
    check(kvm.getKey("test") == STRINGS_EMPTY)
    kvm.setKey("test", "hey")
    check(kvm.len == 1)
    check(kvm.hasKey("test"))
    check(kvm.getKey("test") == "hey")
    kvm.setKey("test", "blah")
    check(kvm.getKey("test") == "blah")
    kvm.dropKey("test")
    check(kvm.getKey("test") == STRINGS_EMPTY)
    check(kvm.len == 0)

  test "test mru":
    let mru = app.getMru()
    check(mru != nil)
    check(mru.len == 0)
    check(not mru.has("something"))
    mru.add("something")
    check(mru.len == 1)
    check(mru.has("something"))
    mru.remove("something")
    check(mru.len == 0)
    check(not mru.has("something"))
    check(mru.getMaximum() == 10)
    mru.setMaximum(3)
    check(mru.getMaximum() == 3)
    mru.add("foo")
    check(mru.len == 1)
    mru.add("bar")
    check(mru.len == 2)
    mru.add("baz")
    check(mru.len == 3)
    check(mru.getAsStringSeq() == @["baz", "bar", "foo"])
    check(mru.getAsJArray() == %* ["baz", "bar", "foo"])
    mru.add("bah")
    check(mru.len == 3)
    check(not mru.has("foo"))
    check(mru.has("bar"))
    check(mru.has("baz"))
    check(mru.has("bah"))
    check(mru.getAsStringSeq() == @["bah", "baz", "bar"])
    check(mru.getAsJArray() == %* ["bah", "baz", "bar"])

  var s: string = STRINGS_EMPTY
  test "test run":
    let evs = app.getEvents()
    check(evs.initializer == DEFAULT_APPEVENT_HANDLER)
    check(evs.main == DEFAULT_APPEVENT_HANDLER)
    check(evs.finalizer == DEFAULT_APPEVENT_HANDLER)
    let nevs: RodsterAppEvents = (initializer: nil, main: nil, finalizer: nil)
    app.setEvents(nevs)
    check(app.getInitializationHandler() == nil)
    check(app.getMainRoutine() == nil)
    check(app.getFinalizationHandler() == nil)
    app.setInitializationHandler (app: RodsterApplication) => (
      check(app.isRunning());
      s = "initialize"
    )
    app.setMainRoutine proc (app: RodsterApplication) =
      check(app.isRunning())
      check(s == "initialize")
      s = "main"
    app.setFinalizationHandler((app: RodsterApplication) => (
      check(app.isRunning());
      check(s == "main");
      s = "finalize"
    ))
    check(app.getInitializationHandler() != nil)
    check(app.getMainRoutine() != nil)
    check(app.getFinalizationHandler() != nil)
    check(not app.isRunning())
    app.run()
    check(not app.isRunning())
    check(s == "finalize")
    check(not app.getSeh().hadException())
    app.setMainRoutine (app: RodsterApplication) => throw(IOError, "blah")
    app.run()
    check(app.getSeh().hadException())
    let e = app.getSeh().getLastException()
    check(e.name == "IOError")
    check(e.msg == "blah")
    app.getSeh().forgetLastException()
    check(not app.getSeh().hadException())
    check(not app.wasTerminated())
    app.setInitializationHandler (app: RodsterApplication) => (s = "from init"; app.terminate())
    app.setMainRoutine (app: RodsterApplication) => (s = "from main")
    app.setFinalizationHandler (app: RodsterApplication) => (s &= " (but finalized)")
    app.run()
    check(s == "from init (but finalized)")
    check(app.wasTerminated())
    app.setInitializationHandler (app: RodsterApplication) => (s = "from init")
    app.setMainRoutine (app: RodsterApplication) => (s = "from main"; app.terminate(); s = "wont happen")
    app.setFinalizationHandler (app: RodsterApplication) => (s &= " (but finalized)")
    app.run()
    check(s == "from main (but finalized)")
    check(app.wasTerminated())
    app.setMainRoutine (app: RodsterApplication) => (s = "blah")
    app.run()
    check(not app.wasTerminated())
    let evs2: RodsterAppEvents = (initializer: nil, main: nil, finalizer: nil)
    let app2 = newRodsterApplication("test", "1.2.3", evs2)
    app2.run()
    check(not app2.isRunning())
    check(not app2.wasTerminated())

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
    check(info.getFilename() != STRINGS.EMPTY)
    check(info.getDirectory() != STRINGS.EMPTY)
    check(info.getProcessId() != STRINGS.EMPTY)
    check(info.getInstanceId() != STRINGS.EMPTY)
    nap(1000)
    check(info.getElapsedSecondsSinceCreation() > 0)
    check(info.getElapsedSecondsSinceCreationAsString() != "0s")
    check(info.getElapsedMinutesSinceCreation() == 0)
    check(info.getElapsedMinutesSinceCreationAsString() == "0m")

  test "test settings":
    let sets = app.getSettings()
    check(sets != nil)
    check(sets.getFilename() == "")
    sets.getModel().defineMandatoryInteger("i").defineMandatoryString("s").defineMandatoryBoolean("b").defineMandatoryFloat("f").registerOptionalArray("a")
    check(sets.getModel().len == 5)
    check(sets.loadFromObject(cfg1))
    check(sets.getAsInteger("i") == 123)
    check(sets.getAsFloat("f") == 123.45)
    check(sets.reload())
    check(sets.getAsBoolean("b") == true)
    check(sets.getAsString("s") == "hello")
    check(sets.has("a"))
    check(sets.getAsJsonNode("a").kind == JArray)
    check(saveJsonNodeToFile(CFG_FILE, cfg2))
    check(sets.loadFromFile(CFG_FILE))
    check(sets.getAsInteger("i") == 456)
    check(sets.getAsFloat("f") == 456.78)
    check(sets.reload())
    check(sets.getAsBoolean("b") == false)
    check(sets.getAsString("s") == "world")
    removeFile(CFG_FILE)

  var s: string = STRINGS.EMPTY
  test "test run":
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

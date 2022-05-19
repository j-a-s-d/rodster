# rodster
##
# LOCALIZATION EXAMPLE

## This example helps to understand how to use the application localization.

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

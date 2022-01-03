# rodster
##
# INTERNATIONALIZATION

import xam, json, strtabs, tables, strutils

type
  TRodsterAppI18n = object
    default: string
    locale: string
    strings: Table[string, StringTableRef]
  RodsterAppI18n* = ref TRodsterAppI18n

proc getCurrentLocale*(i18n: RodsterAppI18n): string =
  ## Returns the current locale.
  i18n.locale

proc setCurrentLocale*(i18n: RodsterAppI18n, locale: string) =
  ## Sets the current locale.
  ## NOTE: if it is the first to be set, it will be established as default also.
  i18n.locale = locale
  if isEmpty(i18n.default):
    i18n.default = locale

proc resetLocaleTexts*(i18n: RodsterAppI18n, locale: string) =
  ## Resets the specified locale texts.
  ## NOTE: strings already loedad in the current locale with be dropped.
  i18n.strings[locale] = newStringTable()

proc hasText*(i18n: RodsterAppI18n, locale: string, key: string): bool =
  ## Checks if the specified key exists at the loaded strings of the specified locale.
  i18n.strings.hasKey(locale) and i18n.strings[locale].hasKey(key)

proc hasText*(i18n: RodsterAppI18n, key: string): bool =
  ## Checks if the specified key exists at the loaded strings of the current locale.
  i18n.hasText(i18n.locale, key)

proc getText*(i18n: RodsterAppI18n, locale: string, key: string, values: seq[string]): string =
  ## Gets the text for the specified key processed with the specified values for the specified locale.
  ## NOTE: if the specified key is not available in the specified locale it will try to load it from the default locale (the first being set).
  ## NOTE: if the specified key requires parameters and the values passed does not satisfy the amount of them, the result will be the original string without replacements.
  proc processText(l: string): string =
    var msg = i18n.strings[l][key]
    silent proc () = msg = msg % values
    return msg
  if i18n.hasText(locale, key):
    processText(locale)
  elif i18n.hasText(i18n.default, key):
    processText(i18n.default)
  else:
    STRINGS_EMPTY

proc getText*(i18n: RodsterAppI18n, key: string, values: seq[string]): string =
  ## Gets the text for the specified key processed with the specified values for the current locale.
  ## NOTE: if the specified key is not available in the specified locale it will try to load it from the default locale (the first being set).
  ## NOTE: if the specified key requires parameters and the values passed does not satisfy the amount of them, the result will be the original string without replacements.
  i18n.getText(i18n.locale, key, values)

proc getText*(i18n: RodsterAppI18n, key: string): string =
  ## Gets the text for the specified key for the current locale.
  ## NOTE: if the specified key is not available in the specified locale it will try to load it from the default locale (the first being set).
  ## NOTE: if the specified key requires parameters and the values passed does not satisfy the amount of them, the result will be the original string without replacements.
  i18n.getText(i18n.locale, key, @[])

proc loadTextsFromJArray*(i18n: RodsterAppI18n, locale: string, arr: JsonNode): bool =
  ## Loads the strings from the specified json object and returns the success result.
  ## NOTE: strings are added to the existing ones for the current locale.
  ## NOTE: if the current locale is not set yet, it is set to this locale by default.
  if isJArray(arr):
    if isEmpty(i18n.locale):
      i18n.setCurrentLocale(locale)
    if not i18n.strings.hasKey(locale):
      i18n.resetLocaleTexts(locale)
    let ls = i18n.strings[locale]
    for x in arr:
      if isJObject(x) and isJString(x["code"]) and isJString(x["message"]):
        ls[x["code"].getStr()] = x["message"].getStr()
    return true

proc loadTextsFromFile*(i18n: RodsterAppI18n, locale: string, filename: string): bool =
  ## Loads the strings from the specified json file and returns the success result.
  ## NOTE: strings are added to the existing ones for the current locale.
  ## NOTE: if the current locale is not set yet, it is set to this locale by default.
  i18n.loadTextsFromJArray(locale, loadJsonNodeFromFile(filename))

proc newRodsterAppI18n*(): RodsterAppI18n =
  ## Constructs a new internationalization object instance.
  result = new TRodsterAppI18n
  result.strings = initTable[string, StringTableRef]()
  result.locale = STRINGS_EMPTY
  result.default = STRINGS_EMPTY

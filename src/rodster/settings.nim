# rodster
##
# SETTINGS

import xam, json

type
  TRodsterAppSettings = object
    model: JsonModel
    filename: string
    fromFile: bool
    data: JsonNode
    validated: bool
    validation: JsonModelValidationResult
  RodsterAppSettings* = ref TRodsterAppSettings

proc has*(sets: RodsterAppSettings, key: string): bool =
  ## Checks if the specified key exists at the currently loaded settings.
  sets.validated && sets.data.hasKey(key)

proc getAsBoolean*(sets: RodsterAppSettings, key: string): bool =
  ## Retrieves the boolean value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getBool()
  else:
    false

proc getAsInteger*(sets: RodsterAppSettings, key: string): int =
  ## Retrieves the integer value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getInt()
  else:
    I0

proc getAsFloat*(sets: RodsterAppSettings, key: string): float =
  ## Retrieves the float value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getFloat()
  else:
    F0

proc getAsString*(sets: RodsterAppSettings, key: string): string =
  ## Retrieves the string value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getStr()
  else:
    STRINGS.EMPTY

proc getAsJsonNode*(sets: RodsterAppSettings, key: string): JsonNode =
  ## Retrieves the json node at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key]
  else:
    nil

proc getLastValidationResult*(sets: RodsterAppSettings): JsonModelValidationResult =
  ## Retrieves the json model validation result.
  sets.validation

proc getModel*(sets: RodsterAppSettings): JsonModel =
  ## Retrieves the json model used to validate the loaded settings.
  sets.model

proc getFilename*(sets: RodsterAppSettings): string =
  ## Retrieves the file name from where the settings are loaded.
  sets.filename

proc loadFromObject*(sets: RodsterAppSettings, obj: JsonNode): bool =
  ## Loads the settings from the specified json object and returns the success result.
  sets.fromFile = false
  sets.validated = false
  if isJObject(obj):
    sets.data = obj
    sets.validation = sets.model.validate(sets.data)
    sets.validated = sets.validation.success
  sets.validated

proc loadFromFile*(sets: RodsterAppSettings, filename: string): bool =
  ## Loads the settings from the specified json file and returns the success result.
  sets.filename = filename
  sets.fromFile = sets.loadFromObject(loadJsonNodeFromFile(sets.filename))
  sets.fromFile

proc reload*(sets: RodsterAppSettings): bool =
  ## Reloads the settings from the original source and returns the success result.
  if sets.fromFile:
    sets.loadFromFile(sets.filename)
  else:
    sets.loadFromObject(sets.data)

proc newRodsterAppSettings*(): RodsterAppSettings =
  ## Constructs a new settings object instance.
  result = new TRodsterAppSettings
  result.model = newJsonModel()
  result.filename = STRINGS.EMPTY
  result.fromFile = false
  result.data = nil
  result.validated = false

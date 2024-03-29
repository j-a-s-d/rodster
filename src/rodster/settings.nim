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

func has*(sets: RodsterAppSettings, key: string): bool =
  ## Checks if the specified key exists at the currently loaded settings.
  sets.validated && sets.data.hasKey(key)

func getAsBoolean*(sets: RodsterAppSettings, key: string, default: bool = false): bool =
  ## Retrieves the boolean value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getBool()
  else:
    default

func getAsInteger*(sets: RodsterAppSettings, key: string, default: int = I0): int =
  ## Retrieves the integer value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getInt()
  else:
    default

func getAsFloat*(sets: RodsterAppSettings, key: string, default: float = F0): float =
  ## Retrieves the float value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getFloat()
  else:
    default

proc getAsString*(sets: RodsterAppSettings, key: string, default: string = STRINGS_EMPTY): string =
  ## Retrieves the string value at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key].getStr()
  else:
    default

func getAsJsonNode*(sets: RodsterAppSettings, key: string, default: JsonNode = newJNull()): JsonNode =
  ## Retrieves the json node at the specified key from the currently loaded settings.
  if sets.has(key):
    sets.data[key]
  else:
    default

func getLastValidationResult*(sets: RodsterAppSettings): JsonModelValidationResult =
  ## Retrieves the json model validation result.
  sets.validation

func getModel*(sets: RodsterAppSettings): JsonModel =
  ## Retrieves the json model used to validate the loaded settings.
  sets.model

func getFilename*(sets: RodsterAppSettings): string =
  ## Retrieves the file name from where the settings are loaded.
  sets.filename

func loadFromJObject*(sets: RodsterAppSettings, obj: JsonNode): bool =
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
  sets.fromFile = sets.loadFromJObject(loadJsonNodeFromFile(sets.filename))
  sets.fromFile

proc reload*(sets: RodsterAppSettings): bool =
  ## Reloads the settings from the original source and returns the success result.
  if sets.fromFile:
    sets.loadFromFile(sets.filename)
  else:
    sets.loadFromJObject(sets.data)

proc newRodsterAppSettings*(): RodsterAppSettings =
  ## Constructs a new settings object instance.
  result = new TRodsterAppSettings
  result.model = newJsonModel()
  result.filename = STRINGS_EMPTY
  result.fromFile = false
  result.data = nil
  result.validated = false

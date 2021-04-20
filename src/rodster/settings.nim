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

proc newRodsterAppSettings*(): RodsterAppSettings =
  result = new TRodsterAppSettings
  result.model = newJsonModel()
  result.filename = STRINGS.EMPTY
  result.fromFile = false
  result.data = nil
  result.validated = false

proc has*(sets: RodsterAppSettings, key: string): bool =
  sets.validated && sets.data.hasKey(key)

proc getAsBoolean*(sets: RodsterAppSettings, key: string): bool =
  if sets.has(key):
    sets.data[key].getBool()
  else:
    false

proc getAsInteger*(sets: RodsterAppSettings, key: string): int =
  if sets.has(key):
    sets.data[key].getInt()
  else:
    I0

proc getAsFloat*(sets: RodsterAppSettings, key: string): float =
  if sets.has(key):
    sets.data[key].getFloat()
  else:
    F0

proc getAsString*(sets: RodsterAppSettings, key: string): string =
  if sets.has(key):
    sets.data[key].getStr()
  else:
    STRINGS.EMPTY

proc getAsJsonNode*(sets: RodsterAppSettings, key: string): JsonNode =
  if sets.has(key):
    sets.data[key]
  else:
    nil

proc getLastValidationResult*(sets: RodsterAppSettings): JsonModelValidationResult =
  sets.validation

proc getModel*(sets: RodsterAppSettings): JsonModel =
  sets.model

proc getFilename*(sets: RodsterAppSettings): string =
  sets.filename

proc loadFromObject*(sets: RodsterAppSettings, obj: JsonNode): bool =
  sets.fromFile = false
  sets.validated = false
  if isJObject(obj):
    sets.data = obj
    sets.validation = sets.model.validate(sets.data)
    sets.validated = sets.validation.success
  sets.validated

proc loadFromFile*(sets: RodsterAppSettings, filename: string): bool =
  sets.filename = filename
  sets.fromFile = sets.loadFromObject(loadJsonNodeFromFile(sets.filename))
  sets.fromFile

proc reload*(sets: RodsterAppSettings): bool =
  if sets.fromFile:
    sets.loadFromFile(sets.filename)
  else:
    sets.loadFromObject(sets.data)

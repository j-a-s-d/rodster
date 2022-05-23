# rodster
##
# MOST RECENTLY USED ITEMS

import xam, json

const
  DEFAULT_MAX_MRU: int = 10

type
  TRodsterAppMru = object
    values: StringSeq
    maximum: int
  RodsterAppMru* = ref TRodsterAppMru

func getAsStringSeq*(mru: RodsterAppMru): StringSeq =
  ## Retrieves the most recently used list as a string sequence.
  mru.values

func getAsJArray*(mru: RodsterAppMru): JsonNode =
  ## Retrieves the most recently used list as a json array.
  result = newJArray()
  for node in mru.values:
    result.add(newJString(node))

func adjust(mru: RodsterAppMru) =
  if mru.values.len > mru.maximum:
    mru.values.setLen(mru.maximum)

func remove*(mru: RodsterAppMru, value: string) =
  ## Removes the specified item from the most recently used list.
  mru.values.remove(value)
  mru.adjust()

func add*(mru: RodsterAppMru, value: string) =
  ## Add the specified item to the most recently used list.
  mru.values = value & mru.values
  mru.adjust()

func has*(mru: RodsterAppMru, value: string): bool =
  ## Determines if the specified item is present in the most recently used list.
  mru.values.contains(value)

func getMaximum*(mru: RodsterAppMru): int =
  ## Gets the max items count of the most recently used list.
  mru.maximum

func setMaximum*(mru: RodsterAppMru, value: int) =
  ## Sets the max items count of the most recently used list.
  if mru.maximum != value:
    mru.maximum = value
    mru.adjust()

func len*(mru: RodsterAppMru): int =
  ## Returns the items count of the most recently used list.
  mru.values.len

func newRodsterAppMru*(): RodsterAppMru =
  ## Constructs a new most recently used items object instance.
  result = new RodsterAppMru
  result.values = newStringSeq()
  result.maximum = DEFAULT_MAX_MRU

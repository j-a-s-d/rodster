# rodster
##
# KEY VALUE MAP

import xam, strtabs

type
  TRodsterAppKvm = object
    values: StringTableRef
  RodsterAppKvm* = ref TRodsterAppKvm

proc dropKey*(kvm: RodsterAppKvm, key: string) =
  ## Removes the specified key from the key value map.
  kvm.values.del(key)

proc setKey*(kvm: RodsterAppKvm, key: string, value: string) =
  ## Sets the value of the specified key from the key value map.
  kvm.values[key] = value

proc getKey*(kvm: RodsterAppKvm, key: string): string =
  ## Gets the value of the specified key from the key value map.
  if kvm.values.hasKey(key):
    return kvm.values[key]

proc `[]=`*(kvm: RodsterAppKvm, key: string, value: string) =
  ## Key value map setter.
  kvm.setKey(key, value)

proc `[]`*(kvm: RodsterAppKvm, key: string): string =
  ## Key value map getter.
  kvm.getKey(key)

proc hasKey*(kvm: RodsterAppKvm, key: string): bool =
  ## Checks if the specified key exists at the key value map.
  kvm.values.hasKey(key)

proc len*(kvm: RodsterAppKvm): int =
  ## Returns the items count at the key value map.
  kvm.values.len

proc newRodsterAppKvm*(): RodsterAppKvm =
  ## Constructs a new key value map object instance.
  result = new TRodsterAppKvm
  result.values = newStringTable()

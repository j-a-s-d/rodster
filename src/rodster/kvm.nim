# rodster
##
# KEY VALUE MAP

import xam, strtabs

type
  TRodsterAppKvm = object
    values: StringTableRef
  RodsterAppKvm* = ref TRodsterAppKvm

func dropKey*(kvm: RodsterAppKvm, key: string) =
  ## Removes the specified key from the key value map.
  kvm.values.del(key)

func setKey*(kvm: RodsterAppKvm, key: string, value: string) =
  ## Sets the value of the specified key from the key value map.
  kvm.values[key] = value

func getKey*(kvm: RodsterAppKvm, key: string): string =
  ## Gets the value of the specified key from the key value map.
  if kvm.values.hasKey(key):
    return kvm.values[key]

func `[]=`*(kvm: RodsterAppKvm, key: string, value: string) =
  ## Key value map setter.
  kvm.setKey(key, value)

func `[]`*(kvm: RodsterAppKvm, key: string): string =
  ## Key value map getter.
  kvm.getKey(key)

func hasKey*(kvm: RodsterAppKvm, key: string): bool =
  ## Checks if the specified key exists at the key value map.
  kvm.values.hasKey(key)

func len*(kvm: RodsterAppKvm): int =
  ## Returns the items count at the key value map.
  kvm.values.len

func newRodsterAppKvm*(): RodsterAppKvm =
  ## Constructs a new key value map object instance.
  result = new TRodsterAppKvm
  result.values = newStringTable()

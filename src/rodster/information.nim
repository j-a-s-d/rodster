# rodster
##
# INFORMATION

import xam, os, oids, times, math, strutils

type
  TRodsterAppInformation = object
    title: string
    version: SemanticVersion
    iid: string
    pid: string
    filename: string
    directory: string
    creation: float
  RodsterAppInformation* = ref TRodsterAppInformation

proc newRodsterAppInformation*(title: string = "", version: string = ""): RodsterAppInformation =
  result = new TRodsterAppInformation
  result.creation = epochTime()
  result.title = title
  result.version = newSemanticVersion(version)
  result.iid = $genOid()
  result.pid = $getCurrentProcessId()
  result.filename = getAppFilename()
  result.directory = getAppDir()

proc setTitle*(info: RodsterAppInformation, title: string) =
  info.title = title

proc setVersion*(info: RodsterAppInformation, version: string) =
  info.version = newSemanticVersion(version)

proc getTitle*(info: RodsterAppInformation): string =
  info.title

proc getVersion*(info: RodsterAppInformation): SemanticVersion =
  info.version

proc getInstanceId*(info: RodsterAppInformation): string =
  info.iid

proc getProcessId*(info: RodsterAppInformation): string =
  info.pid

proc getFilename*(info: RodsterAppInformation): string =
  info.filename

proc getDirectory*(info: RodsterAppInformation): string =
  info.directory

proc calculateElapsedSecondsSinceCreation*(info: RodsterAppInformation): float =
  epochTime() - info.creation

proc getElapsedSecondsSinceCreation*(info: RodsterAppInformation): int =
  toInt(floor(info.calculateElapsedSecondsSinceCreation()))

proc getElapsedSecondsSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_S): string =
  info.calculateElapsedSecondsSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

proc calculateElapsedMinutesSinceCreation*(info: RodsterAppInformation): float =
  info.getElapsedSecondsSinceCreation() / 60

proc getElapsedMinutesSinceCreation*(info: RodsterAppInformation): int =
  toInt(floor(info.calculateElapsedMinutesSinceCreation()))

proc getElapsedMinutesSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_M): string =
  info.calculateElapsedMinutesSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

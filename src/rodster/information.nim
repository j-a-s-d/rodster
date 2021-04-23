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

proc setTitle*(info: RodsterAppInformation, title: string) =
  ## Establishes the application title.
  info.title = title

proc setVersion*(info: RodsterAppInformation, version: string) =
  ## Establishes the application version.
  ## NOTE: It must be a semantic version string value (ex. "1.0.0").
  info.version = newSemanticVersion(version)

proc getTitle*(info: RodsterAppInformation): string =
  ## Retrieves the application title.
  info.title

proc getVersion*(info: RodsterAppInformation): SemanticVersion =
  ## Retrieves the application semantic version object instance.
  info.version

proc getInstanceId*(info: RodsterAppInformation): string =
  ## Retrieves the application instance identifier.
  info.iid

proc getProcessId*(info: RodsterAppInformation): string =
  ## Retrieves the application process identifier.
  info.pid

proc getFilename*(info: RodsterAppInformation): string =
  ## Retrieves the application file name.
  info.filename

proc getDirectory*(info: RodsterAppInformation): string =
  ## Retrieves the application directory path.
  info.directory

proc calculateElapsedSecondsSinceCreation*(info: RodsterAppInformation): float =
  ## Retrieves the amount of seconds elapsed since the application was created as a float value.
  epochTime() - info.creation

proc getElapsedSecondsSinceCreation*(info: RodsterAppInformation): int =
  ## Retrieves the amount of seconds elapsed since the application was created as an integer value.
  toInt(floor(info.calculateElapsedSecondsSinceCreation()))

proc getElapsedSecondsSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_S): string =
  ## Retrieves the amount of seconds elapsed since the application was created as a string value
  ## add the specified appendix (by default 's').
  info.calculateElapsedSecondsSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

proc calculateElapsedMinutesSinceCreation*(info: RodsterAppInformation): float =
  ## Retrieves the amount of minutes elapsed since the application was created as a float value.
  info.getElapsedSecondsSinceCreation() / 60

proc getElapsedMinutesSinceCreation*(info: RodsterAppInformation): int =
  ## Retrieves the amount of minutes elapsed since the application was created as an integer value.
  toInt(floor(info.calculateElapsedMinutesSinceCreation()))

proc getElapsedMinutesSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_M): string =
  ## Retrieves the amount of minutes elapsed since the application was created as a string value
  ## add the specified appendix (by default 'm').
  info.calculateElapsedMinutesSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

proc newRodsterAppInformation*(title: string = "", version: string = ""): RodsterAppInformation =
  ## Constructs a new information object instance.
  result = new TRodsterAppInformation
  result.creation = epochTime()
  result.title = title
  result.version = newSemanticVersion(version)
  result.iid = $genOid()
  result.pid = $getCurrentProcessId()
  result.filename = getAppFilename()
  result.directory = getAppDir()

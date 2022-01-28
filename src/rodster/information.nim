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
    directory: string
    filename: string
    arguments: StringSeq
    creation: float
  RodsterAppInformation* = ref TRodsterAppInformation

func setTitle*(info: RodsterAppInformation, title: string) =
  ## Establishes the application title.
  info.title = title

func setVersion*(info: RodsterAppInformation, version: string) =
  ## Establishes the application version.
  ## NOTE: It must be a semantic version string value (ex. "1.0.0").
  info.version = newSemanticVersion(version)

func getTitle*(info: RodsterAppInformation): string =
  ## Retrieves the application title.
  info.title

func getVersion*(info: RodsterAppInformation): SemanticVersion =
  ## Retrieves the application semantic version object instance.
  info.version

func getInstanceId*(info: RodsterAppInformation): string =
  ## Retrieves the application instance identifier.
  info.iid

func getProcessId*(info: RodsterAppInformation): string =
  ## Retrieves the application process identifier.
  info.pid

func getDirectory*(info: RodsterAppInformation): string =
  ## Retrieves the application directory path.
  info.directory

func getFilename*(info: RodsterAppInformation): string =
  ## Retrieves the application file name.
  info.filename

func getArguments*(info: RodsterAppInformation): StringSeq =
  ## Retrieves the application arguments as a sequence of strings.
  info.arguments

func hasArgument*(info: RodsterAppInformation, values: varargs[string]): bool =
  ## Retrieves true if any of the application arguments matches any of the specified values.
  values.each value:
    if value in info.arguments:
      return true
  return false

func findArgumentsWithPrefix*(info: RodsterAppInformation, prefixes: openarray[string]): IntSeq =
  ## Retrieves a sequence of the indexes where the application arguments start with any of the specified prefixes.
  result = @[]
  var x = 0
  info.arguments.each arg:
    prefixes.each prefix:
      if arg.startsWith(prefix):
        result.add(x)
    inc x

func getArgumentWithoutPrefix*(info: RodsterAppInformation, index: int, prefixes: openarray[string]): string =
  ## Retrieves the specified application argument without the also specified matching prefix (if any).
  result = info.arguments[index]
  prefixes.each prefix:
    if result.startsWith(prefix):
      return result.replace(prefix, STRINGS_EMPTY)

func calculateElapsedSecondsSinceCreation*(info: RodsterAppInformation): float =
  ## Retrieves the amount of seconds elapsed since the application was created as a float value.
  epochTime() - info.creation

func getElapsedSecondsSinceCreation*(info: RodsterAppInformation): int =
  ## Retrieves the amount of seconds elapsed since the application was created as an integer value.
  toInt(floor(info.calculateElapsedSecondsSinceCreation()))

func getElapsedSecondsSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_S): string =
  ## Retrieves the amount of seconds elapsed since the application was created as a string value
  ## add the specified appendix (by default 's').
  info.calculateElapsedSecondsSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

func calculateElapsedMinutesSinceCreation*(info: RodsterAppInformation): float =
  ## Retrieves the amount of minutes elapsed since the application was created as a float value.
  info.getElapsedSecondsSinceCreation() / 60

func getElapsedMinutesSinceCreation*(info: RodsterAppInformation): int =
  ## Retrieves the amount of minutes elapsed since the application was created as an integer value.
  toInt(floor(info.calculateElapsedMinutesSinceCreation()))

func getElapsedMinutesSinceCreationAsString*(info: RodsterAppInformation, appendix: string = STRINGS_LOWERCASE_M): string =
  ## Retrieves the amount of minutes elapsed since the application was created as a string value
  ## add the specified appendix (by default 'm').
  info.calculateElapsedMinutesSinceCreation().formatFloat(format = ffDecimal, precision = 0).replace(STRINGS_PERIOD, appendix)

proc newRodsterAppInformation*(title: string = STRINGS_EMPTY, version: string = STRINGS_EMPTY): RodsterAppInformation =
  ## Constructs a new information object instance.
  result = new TRodsterAppInformation
  result.creation = epochTime()
  result.title = title
  result.version = newSemanticVersion(version)
  result.iid = $genOid()
  result.pid = $getCurrentProcessId()
  result.directory = getAppDir()
  result.filename = getAppFilename()
  result.arguments = commandLineParams()

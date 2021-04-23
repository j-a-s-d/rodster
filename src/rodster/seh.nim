# rodster
##
# SELF-EXCEPTION HANDLING

import xam, times

type
  TRodsterAppSeh = object
    lastException: ref Exception
    lastExceptionTime: float
  RodsterAppSeh* = ref TRodsterAppSeh

proc hadException*(seh: RodsterAppSeh): bool =
  ## Determines if the exception handler has an exception caught.
  seh.lastException != nil

proc getLastException*(seh: RodsterAppSeh): ref Exception =
  ## Retrieves the last exception caught.
  seh.lastException

proc getLastExceptionTime*(seh: RodsterAppSeh): float =
  ## Retrieves the last exception timestamp.
  seh.lastExceptionTime

proc setLastException*(seh: RodsterAppSeh, e: ref Exception) =
  ## Sets the exception as the last to be caught and records the current time.
  seh.lastException = e
  seh.lastExceptionTime = epochTime()

proc forgetLastException*(seh: RodsterAppSeh) =
  ## Drops the last exception caught.
  seh.lastException = nil
  seh.lastExceptionTime = NaN

proc newRodsterAppSeh*(): RodsterAppSeh =
  ## Constructs a new self-exception handler object instance.
  result = new TRodsterAppSeh
  result.forgetLastException()

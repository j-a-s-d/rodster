# rodster
##
# SELF-EXCEPTION HANDLING

import xam, times

type
  TRodsterAppSeh = object
    lastException: ref Exception
    lastExceptionTime: float
  RodsterAppSeh* = ref TRodsterAppSeh

func hadException*(seh: RodsterAppSeh): bool =
  ## Determines if the exception handler has an exception caught.
  seh.lastException != nil

func getLastException*(seh: RodsterAppSeh): ref Exception =
  ## Retrieves the last exception caught.
  seh.lastException

func getLastExceptionTime*(seh: RodsterAppSeh): float =
  ## Retrieves the last exception timestamp.
  seh.lastExceptionTime

func setLastException*(seh: RodsterAppSeh, e: ref Exception) =
  ## Sets the exception as the last to be caught and records the current time.
  seh.lastException = e
  seh.lastExceptionTime = epochTime()

func forgetLastException*(seh: RodsterAppSeh) =
  ## Drops the last exception caught.
  seh.lastException = nil
  seh.lastExceptionTime = NaN

func newRodsterAppSeh*(): RodsterAppSeh =
  ## Constructs a new self-exception handler object instance.
  result = new TRodsterAppSeh
  result.forgetLastException()

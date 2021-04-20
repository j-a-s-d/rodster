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
  seh.lastException != nil

proc getLastException*(seh: RodsterAppSeh): ref Exception =
  seh.lastException

proc getLastExceptionTime*(seh: RodsterAppSeh): float =
  seh.lastExceptionTime

proc setLastException*(seh: RodsterAppSeh, e: ref Exception) =
  seh.lastException = e
  seh.lastExceptionTime = epochTime()

proc forgetLastException*(seh: RodsterAppSeh) =
  seh.lastException = nil
  seh.lastExceptionTime = NaN

proc newRodsterAppSeh*(): RodsterAppSeh =
  result = new TRodsterAppSeh
  result.forgetLastException()

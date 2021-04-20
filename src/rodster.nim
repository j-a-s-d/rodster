# rodster
##
# DEFINITIONS AND INCLUDES

when defined(nimHasUsed):
  {.used.}

import xam

let
  VERSION* = newSemanticVersion(0, 1, 0)

reexport(rodster/application, application)

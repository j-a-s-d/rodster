# rodster
##
# PRIMARY SOURCE

# DEFINITIONS AND INCLUDES

when defined(nimHasUsed):
  {.used.}

import xam

reexport(rodster/application, application)

# CONSTANTS

let
  VERSION* = newSemanticVersion(0, 3, 0)

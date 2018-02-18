# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL
stty stop undef
stty stop ''
stty start ''
stty -ixon
stty -ixoff

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc. (An initial unquoted ‘~’ always produces named directory expansion.)
# setopt EXTENDED_GLOB

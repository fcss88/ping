##!/bin/bash

set -euxo pipefail

# set -e
# stop on error, write error message to stderr.
# if u use 'some-command | true' and 'some-command' fails, the script will continue.

# set -u
# stop on undefined variables, write error message to stderr.

# set -x
# write each command to stdout before executing it.

# set -o pipefail 
# stop on error in a pipeline, write error message to stderr.
# if u use 'some-command | true' and 'some-command' fails, the script will continue.
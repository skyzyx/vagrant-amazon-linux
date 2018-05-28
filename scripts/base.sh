#! /usr/bin/env bash

# Show Errors
set -euxo pipefail

e() {
  echo -e "  \e[1;32m[install] ==> $@\e[0m";
}

e "Add a permanent datestamp for the image."
echo "$(date -I)" > /etc/ami-build-time

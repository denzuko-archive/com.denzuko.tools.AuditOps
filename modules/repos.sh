#!/bin/bash
###############################################################################
#
# AuditOps - version 1.0
#
# Based on assert.sh 1.0 - bash unit testing framework
# http://github.com/lehmannro/assert.sh
# http://github.com/denzuko/AuditOps
#
# AuditOps - Copyrighted 2013 Dwight Spencer. All rights Reserved.
# Licenced under GNUv3 licencing.
#
# Authors:
#
#   - Dwight Spencer (@denzuko) <dwight.spencer@firehost.com>
#
# Contributors:
#
################################################################################
_MirrorBase() {
  case "$(_Distro)" in
	rpm) echo "/etc/yum.repos.d";;
	deb) echo "/etc/apt";;
  esac
}

_MirrorList() {
  local BASE
  BASE=$(_MirrorBase)
  find "${BASE}" -type f \( -name \*.repo -or -name \*.list \) -print0 | xargs -0 -I{} -P4 -- cat {} 
}

_MirrorUrl () {
  while read line; do
        echo "${line}" | sed 's/^.*\(\(ht\|f\)tp:\/\/\([^\/]\+\)\/\).*$/\1/gp;d';
  done
}

_LastUpdated() {
  case "${DISTRO}" in
	rpm) yum history;;
	deb) tail -n1 /var/log/apt/history.log;;
  esac
}

_AvailableUpdates() {
  case "${DISTRO}" in
	rpm) yum check-update; return $?;;
	deb) apt-get --assume-no -u upgrade; return $?;;
  esac
}

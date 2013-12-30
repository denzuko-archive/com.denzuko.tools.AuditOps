#!/bin/bash
###############################################################################
# Linux Patch Auditor
# Version: 1.0
#
# Based on assert.sh 1.0 - bash unit testing framework and AuditOps 0.1
# http://github.com/lehmannro/assert.sh
# http://github.com/denzuko/AuditOps
#
# AuditOps - Copyrighted 2013 Dwight Spencer. All rights Reserved.
# Linux Patch Auditor - Copyrighted 2014 Firehost, Inc. All rights Reserved.
# Licenced under GNUv3 licencing.
#
# Authors:
#
#   - Dwight Spencer (@denzuko) <dwight.spencer@firehost.com>
#
# Contributors:
#
################################################################################
################################################################################
# Helpers
################################################################################

_GET() {
  curl  -m 1 -sIL ${1} | head -n1 | cut -d' ' -f2
}

_Distro() {
  ( _isRPM && echo "rpm" ) || ( _isApt && echo "deb" )
}

_isApt() {
  which apt-get 2>&1 >/dev/null; return $?
}

_isRPM() {
  which yum 2>&1 >/dev/null; return $?
}

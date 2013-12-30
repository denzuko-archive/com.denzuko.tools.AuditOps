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
_ConfigChanges() {
  case "${DISTRO}" in
	rpm) rpm -Va 2>/dev/null | sed '/\/etc\/\([^\/]\+\).*$/p;d';;
	deb) ( which debsum 2>/dev/null >/dev/null) && debsum -ce;;
  esac
}

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
. assert.sh
. helpers.sh
. repos.sh
. configcheck.sh
. monitoring.sh

################################################################################
# Sanity Checks
################################################################################

assert "id -u" "0"

DISTRO=$(_Distro)
assert "( [ ${DISTRO} == 'deb' ] || [ ${DISTRO} == 'rpm' ] ) && echo 0" "0"

assert_end "Sanity Tests"
echo

###############################################################################
# Unit Tests
###############################################################################

echo "= Linux Patch Audit ="
echo -ne "$(hostname -I | rev | cut -d' ' -f1 | rev).$(date +%s)\n$(uptime)\n\n"

echo "== Repository Checks =="

# Find Mirrors
case "${DISTRO}" in
	rpm) assert "_MirrorBase" "/etc/yum.repos.d";;
	deb) assert "_MirrorBase" "/etc/apt";;
esac

MirrorList=$(_MirrorList)
MIRRORS=( $(echo $MirrorList | _MirrorUrl | sort -u) )
assert "[ \"${#MIRRORS[@]}\" -gt 0 ] && echo $?" "0"
assert_end "Find Mirrors" || _MirrorList

# "Ensure Repo Availablity"
for url in "${MIRRORS[@]}"; do
  assert "_GET ${url}" "200"
done

panopta_url="$(_MonitoringAgentUrl)"
assert "[ \"$panopta_url\" != \"\" ] && echo $?" "0"
assert "_GET ${panopta_url}" "200"
assert_end "Reposistory Availablity"

echo -ne "\n== Changes to repositories ==\n${MirrorList}\n"

echo -ne "\n== Last Time Updated ==\n"
UpdateLog=$(_LastUpdated)
assert "[ \"$UpdateLog\" != \"\" ] && echo 0" "0" && echo "${UpdateLog}"

PatchLog=$(_AvailableUpdates)
case "$?" in
	100) echo -ne "\n== Patches Available ==\n"
	     assert "[ \"$PatchLog\" != \"\" ] && echo $?" "0"
	     echo "${PatchLog}";;
	  0) ;;
esac
assert_end "System Updates"


echo -ne "\n== Monitoring Agent installation == \N"
package="/tmp/$(basename ${panopta url})"
curl ${panopta_url} -s > "${package}"

#vim: syn=shell ft=sh syn on:

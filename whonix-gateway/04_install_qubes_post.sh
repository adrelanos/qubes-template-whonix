#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :

if [ "$VERBOSE" -ge 2 -o "$DEBUG" == "1" ]; then
    set -x
fi

source "${SCRIPTSDIR}/vars.sh"
source "${SCRIPTSDIR}/distribution.sh"

##### '-------------------------------------------------------------------------
debug ' Installing qubes-whonix package(s)'
##### '-------------------------------------------------------------------------


# If .prepared_debootstrap has not been completed, don't continue
exitOnNoFile "${INSTALLDIR}/${TMPDIR}/.prepared_qubes" "prepared_qubes installataion has not completed!... Exiting"

# Create system mount points.
prepareChroot


#### '--------------------------------------------------------------------------
info ' Trap ERR and EXIT signals and cleanup (umount)'
#### '--------------------------------------------------------------------------
trap cleanup ERR
trap cleanup EXIT

#### '--------------------------------------------------------------------------
info ' Installing qubes-whonix and other required packages'
#### '--------------------------------------------------------------------------
# whonix-setup-wizard expects '/usr/local/share/applications' directory to exist
chroot mkdir -p '/usr/local/share/applications'  # whonix-setup-wizard needs this

installQubesRepo
aptInstall qubes-whonix
uninstallQubesRepo

#### '----------------------------------------------------------------------
info ' Re-update locales'
####   (Locales get reset during package installation sometimes)
#### '----------------------------------------------------------------------
updateLocale

#### '--------------------------------------------------------------------------
info ' Cleanup'
#### '--------------------------------------------------------------------------
umount_all "${INSTALLDIR}/" || true
trap - ERR EXIT
trap

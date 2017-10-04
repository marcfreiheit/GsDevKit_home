#! /usr/bin/env bash
#=========================================================================
# Copyright (c) 2015, 2-16 GemTalk Systems, LLC <dhenrich@gemtalksystems.com>.
#
#   MIT license: https://github.com/GsDevKit/GsDevKit_home/blob/master/license.txt
#=========================================================================

# use TotalMem: kB because Ubuntu doesn't have Mem: in Bytes
totalMemKB=`awk '/MemTotal:/{print($2);}' /proc/meminfo`
totalMem=$(($totalMemKB * 1024))
# Figure out the max shared memory segment size currently allowed
shmmax=`cat /proc/sys/kernel/shmmax`
# Figure out the max shared memory currently allowed
shmall=`cat /proc/sys/kernel/shmall`
;;

totalMemMB=$(($totalMem / 1048576))
shmmaxMB=$(($shmmax / 1048576))
shmallMB=$(($shmall / 256))

# Print current values
echo "  Total memory available is $totalMemMB MB"
echo "  Max shared memory segment size is $shmmaxMB MB"
echo "  Max shared memory allowed is $shmallMB MB"

# Figure out the max shared memory segment size (shmmax) we want
# Use 75% of available memory but not more than 2GB
shmmaxNew=$(($totalMem * 3/4))
[ $shmmaxNew -gt 2147483648 ] && shmmaxNew=2147483648
shmmaxNewMB=$(($shmmaxNew / 1048576))

# Figure out the max shared memory allowed (shmall) we want
# The MacOSX default is 4MB, way too small
# The Linux default is 2097152 or 8GB, so we should never need this
# but things will certainly break if it's been reset too small
# so ensure it's at least big enough to hold a fullsize shared memory segment
shmallNew=$(($shmmaxNew / 4096))
[ $shmallNew -lt $shmall ] && shmallNew=$shmall
shmallNewMB=$(($shmallNew / 256))

# Increase shmmax if appropriate
if [ $shmmaxNew -gt $shmmax ]; then
    echo "[Info] Increasing max shared memory segment size to $shmmaxNewMB MB"
    bash -c "echo $shmmaxNew > /proc/sys/kernel/shmmax" \
    && sudo /bin/su -c "echo 'kernel.shmmax=$shmmaxNew' >>/etc/sysctl.conf"
else
e   cho "[Info] No need to increase max shared memory segment size"
fi

# Now setup for NetLDI in case we ever need it.
echo "[Info] Setting up GemStone netldi service port"
if [ `grep -sc "^gs64ldi" /etc/services` -eq 0 ]; then
    echo '[Info] Adding "gs64ldi  50377/tcp" to /etc/services'
    sudo bash -c 'echo "gs64ldi         50377/tcp        # Gemstone netldi"  >> /etc/services'
else
    echo "[Info] GemStone netldi service port is already set in /etc/services"
    echo "To change it, remove the following line from /etc/services and rerun this script"
    grep "^gs64ldi" /etc/services
fi

# Create some directories that GemStone expects; make them writable
echo "[Info] Creating /opt/gemstone directory"
if [ ! -e /opt/gemstone ]
then
    mkdir -p /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    chown $USER:${GROUPS[0]} /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
    chmod 770 /opt/gemstone /opt/gemstone/log /opt/gemstone/locks
else
echo "[Warning] /opt/gemstone directory already exists"
echo "to replace it, remove or rename it and rerun this script"
fi
cat - > $sharedMemorySysSetup << EOF
the presence of this file means that \$GS_HOME/bin/installOsPrereqs has 
set up shared memory for GemStone/S 64
EOF

cat - > $osPrereqsSysSetup << EOF
the presence of this file means that \$GS_HOME/bin/installOsPrereqs has 
installed the prerequisites for GemStone/S 64
EOF

cat - > $gsdevkitSysSetup << EOF
the presence of this file means that \$GS_HOME/bin/installOsPrereqs has 
configured the OS for running GemStone/S 64, including the setup of shared memory
EOF

# End of script
exit_0_banner "...finished"
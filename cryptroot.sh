#!/bin/sh

PATH=$PATH:/sbin:/bin:/usr/bin

abort() {
    echo "ERROR: $@"
    exit 1
}

# Kill cryptroot process
for p in `pidof cryptroot`
do
    kill -9 $p
done

# Check if cryptroot has terminated
pidof cryptroot > /dev/null && abort "cryptroot is still running."
echo "cryptroot has terminated."

echo "Waiting for /bin/sh -i to start..."
SH_PID=`ps | grep 'sh -i' | grep -v grep | awk '{print $1}'`
while [ -z "$SH_PID" ]
do
    SH_PID=`ps | grep 'sh -i' | grep -v grep | awk '{print $1}'`
    sleep 3
done
ps | grep 'sh -i' | grep -v grep
echo "sh -i has started."

# prompt for password
echo
/scripts/local-top/cryptroot
if [ $? -eq 0 ]; then
    echo "Terminating sh -i process..."
    sleep 3
    SH_PID=`ps | grep 'sh -i' | grep -v grep | awk '{print $1}'`
    if [ -n "$SH_PID" ]; then
        kill -9 $SH_PID
        sleep 3
    else
        abort "/bin/sh -i process not found"
    fi
else
    abort "/scripts/local-top/cryptroot failed"
fi

echo "Press ctrl-d or type exit to disconnect from initrd dropbear."

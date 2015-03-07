#!/bin/sh

#-------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2015 Alvin Abad
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#-------------------------------------------------------------------------------

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

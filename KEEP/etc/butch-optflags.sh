#!/bin/sh

# put your custom cflags and ldflags here...
# this file is sourced by the default butch build template

isgcc3() {
	local mycc="$CC"
	[ -z "$mycc" ] && mycc=gcc
	$mycc --version | grep "3.4.6" >/dev/null
}

optcflags="-fdata-sections -ffunction-sections -Os -g0 -fno-unwind-tables -fno-asynchronous-unwind-tables -Wa,--noexecstack"
optldflags="-s -Wl,--gc-sections -Wl,-z,relro,-z,now"

if [ "$DEBUGBUILD" = "1" ] ; then
	# use "DEBUGBUILD=1 butch install mypkg" to create debug version of mypkg
	optcflags="-O0 -g3"
	optldflags=
else
	[ "$STAGE" = "0" ] || isgcc3 || optcflags="$optcflags -ftree-dce"
fi

if [ "$BRUTE" = 2 ] ; then
	optcflags="$optcflags -s -Os -flto -fwhole-program"
	optldflags="$optldflags -flto -fwhole-program"
elif [ "$BRUTE" = 1 ] ; then
        optcflags="$optcflags -s -Os -flto"
        optldflags="$optldflags -flto"
fi

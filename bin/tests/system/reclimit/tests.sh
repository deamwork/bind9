#!/bin/sh
#
# Copyright (C) 2014-2016  Internet Systems Consortium, Inc. ("ISC")
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

SYSTEMTESTTOP=..
. $SYSTEMTESTTOP/conf.sh

DIGOPTS="-p 5300"

status=0
n=0

n=`expr $n + 1`
echo "I: attempt excessive-depth lookup ($n)"
ret=0
echo "1000" > ans2/ans.limit
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect1.example.org > dig.out.1.test$n || ret=1
grep "status: SERVFAIL" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
if [ "$TESTSOCK6" != "false" ]
then
  [ $count -eq 26 ] || { ret=1; echo "I: count ($count) != 26"; }
else
  [ $count -eq 14 ] || { ret=1; echo "I: count ($count) != 14"; }
fi
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

n=`expr $n + 1`
echo "I: attempt permissible lookup ($n)"
ret=0
sleep 2
echo "12" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect2.example.org > dig.out.1.test$n || ret=1
grep "status: NOERROR" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
if [ "$TESTSOCK6" != "false" ]
then
  [ $count -eq 49 ] || { ret=1; echo "I: count ($count) != 49"; }
else
  [ $count -eq 26 ] || { ret=1; echo "I: count ($count) != 26"; }
fi
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

echo "I:reset max-recursion-depth"
cp ns3/named2.conf ns3/named.conf
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 reconfig 2>&1 | sed 's/^/I:ns1 /'
sleep 2

n=`expr $n + 1`
echo "I: attempt excessive-depth lookup ($n)"
ret=0
echo "12" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect3.example.org > dig.out.1.test$n || ret=1
grep "status: SERVFAIL" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
if [ "$TESTSOCK6" != "false" ]
then
  [ $count -eq 12 ] || { ret=1; echo "I: count ($count) != 12"; }
else
  [ $count -eq 7 ] || { ret=1; echo "I: count ($count) != 7"; }
fi
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

n=`expr $n + 1`
echo "I: attempt permissible lookup ($n)"
ret=0
echo "5" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect4.example.org > dig.out.1.test$n || ret=1
grep "status: NOERROR" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
if [ "$TESTSOCK6" != "false" ]
then
  [ $count -eq 21 ] || { ret=1; echo "I: count ($count) != 21"; }
else
  [ $count -eq 12 ] || { ret=1; echo "I: count ($count) != 12"; }
fi
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

echo "I:reset max-recursion-depth"
cp ns3/named3.conf ns3/named.conf
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 reconfig 2>&1 | sed 's/^/I:ns1 /'
sleep 2

n=`expr $n + 1`
echo "I: attempt excessive-queries lookup ($n)"
ret=0
echo "13" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect5.example.org > dig.out.1.test$n || ret=1
if [ "$TESTSOCK6" != "false" ]
then
  grep "status: SERVFAIL" dig.out.1.test$n > /dev/null || ret=1
fi
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
[ $count -le 50 ] || { ret=1; echo "I: count ($count) !<= 50"; }
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

n=`expr $n + 1`
echo "I: attempt permissible lookup ($n)"
ret=0
echo "12" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect6.example.org > dig.out.1.test$n || ret=1
grep "status: NOERROR" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
[ $count -le 50 ] || { ret=1; echo "I: count ($count) !<= 50"; }
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

echo "I:reset max-recursion-queries"
cp ns3/named4.conf ns3/named.conf
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 reconfig 2>&1 | sed 's/^/I:ns1 /'
sleep 2

n=`expr $n + 1`
echo "I: attempt excessive-queries lookup ($n)"
ret=0
echo "10" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect7.example.org > dig.out.1.test$n || ret=1
if [ "$TESTSOCK6" != "false" ]
then
  grep "status: SERVFAIL" dig.out.1.test$n > /dev/null || ret=1
fi
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
[ $count -le 40 ] || { ret=1; echo "I: count ($count) !<= 40"; }
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

n=`expr $n + 1`
echo "I: attempt permissible lookup ($n)"
ret=0
echo "9" > ans2/ans.limit
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS @10.53.0.2 reset > /dev/null || ret=1
$DIG $DIGOPTS @10.53.0.3 indirect8.example.org > dig.out.1.test$n || ret=1
grep "status: NOERROR" dig.out.1.test$n > /dev/null || ret=1
$DIG $DIGOPTS +short @10.53.0.2 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
[ $count -le 40 ] || { ret=1; echo "I: count ($count) !<= 40"; }
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

n=`expr $n + 1`
echo "I: attempting NS explosion ($n)"
ret=0
$RNDC -c ../common/rndc.conf -s 10.53.0.3 -p 9953 flush 2>&1 | sed 's/^/I:ns1 /'
$DIG $DIGOPTS +short @10.53.0.3 ns1.1.example.net > dig.out.1.test$n || ret=1
sleep 2
$DIG $DIGOPTS +short @10.53.0.4 count txt > dig.out.2.test$n || ret=1
eval count=`cat dig.out.2.test$n`
[ $count -lt 50 ] || ret=1
$DIG $DIGOPTS +short @10.53.0.7 count txt > dig.out.3.test$n || ret=1
eval count=`cat dig.out.3.test$n`
[ $count -lt 50 ] || { ret=1; echo "I: count ($count) !<= 50";  }
if [ $ret != 0 ]; then echo "I:failed"; fi
status=`expr $status + $ret`

echo "I:exit status: $status"
[ $status -eq 0 ] || exit 1

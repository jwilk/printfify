#!/bin/sh

# Copyright © 2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

basedir="${0%/*}/.."
prog="$basedir/printfify"
echo 1..1
tmpdir=$(mktemp -d -t printfify.XXXXXX)
"$prog" --help > "$tmpdir/help.orig"
"$prog" < "$tmpdir/help.orig" > "$tmpdir/help.sh"
cd "$tmpdir"
sh help.sh > help.pf
if cmp -s help.orig help.pf
then
    echo ok 1 round trip OK
else
    diff -u help.orig help.pf | sed -e 's/^/# /'
    echo not ok 1 round trip failed
fi
cd /
rm -rf "$tmpdir"

# vim:ts=4 sts=4 sw=4 et ft=sh

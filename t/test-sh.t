#!/bin/sh

# Copyright © 2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

name="${0##*/}"
name="${name%.t}"
sh="${name#test-}"
if [ "$sh" != sh ] && ! command -v "$sh" > /dev/null
then
    echo 1..0 "# skip $sh not found"
    exit 0
fi
basedir="${0%/*}/.."
prog="$basedir/printfify"
echo 1..1
tmpdir=$(mktemp -d -t printfify.XXXXXX)
"$prog" --help > "$tmpdir/help.orig"
"$prog" < "$tmpdir/help.orig" > "$tmpdir/help.sh"
cd "$tmpdir"
echo "# sh = $sh"
"$sh" help.sh > help.pf
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

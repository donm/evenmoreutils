#!/bin/bash

poptail () { bash ../bin/poptail "$@"; }

source ../bin/poptail


setUp () {
    test_tmpfile=$(mktemp --tmpdir "peeif.XXXXXX")
}

tearDown () {
    rm "$test_tmpfile"
}

test_basic () {
    seq 20 > "$test_tmpfile"
    response=$(poptail "$test_tmpfile")
    assertSame "$(seq 11 20)" \
               "$response"

    response=$(cat "$test_tmpfile")
    assertSame "lines have been popped" \
               "$(seq 10)" \
               "$response"

}

test_lines_flag () {
    seq 20 > "$test_tmpfile"
    response=$(poptail -n 2 "$test_tmpfile")
    assertSame "$(seq 19 20)" \
               "$response"

    response=$(poptail -n +15 "$test_tmpfile")
    assertSame "works with + character" \
               "$(seq 15 18)" \
               "$response"
}

test_bytes_flag () {
    echo -n "ABCD葉" >> "$test_tmpfile"
    response=$(poptail -c 3 "$test_tmpfile")
    assertSame "葉" \
               "$response"
    response=$(poptail -c 2 "$test_tmpfile")
    assertSame "CD" \
               "$response"
}

test_dry_run () {
    seq 20 > "$test_tmpfile"
    response=$(poptail -N "$test_tmpfile" | head -n 10)
    assertSame "$(seq 11 20)" \
               "$response"

    response=$(poptail -N -n 2 "$test_tmpfile" | head -n 2)
    assertSame "$(seq 19 20)" \
               "$response"

    response=$(cat "$test_tmpfile")
    assertSame "lines have not changed" \
               "$(seq 20)" \
               "$response"
}

test_errors () {
    response=$(poptail  2>&1 | grep "missing file argument")
    assertNotEquals "" \
                    "$response"
    response=$(poptail two files 2>&1 | grep "too many arguments")
    assertNotEquals "" \
                    "$response"
    response=$(poptail -c 2>&1 | grep "option requires an argument")
    assertNotEquals "" \
                    "$response"
    response=$(poptail -n 2>&1 | grep "option requires an argument")
    assertNotEquals "" \
                    "$response"
    response=$(poptail -x 2>&1 | grep "illegal")
    assertNotEquals "" \
                    "$response"
}

test_help_flag () {
    response=$(poptail -h)
    # have to eat the newline at the end
    assertSame "$(echo "$help_msg")" \
               "$response"
}

test_version_flag () {
    response=$(poptail -v)
    # have to eat the newline at the end
    assertSame "$(echo "$version_msg")" \
               "$response"
}

. ../external/shunit2

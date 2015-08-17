#!/bin/bash

peeif () { bash ../peeif "$@"; }

source ../peeif

test_basic () {
    response=$(echo "ABC" | peeif "tr 'A' 'Z'")
    assertSame "ZBC" \
               "$response"
    response=$(echo "ABC" | peeif "tr 'A' 'Z'" "tr 'B' 'Y'")
    assertSame $'ZBC\nAYC' \
               "$response"

    response=$(echo "ABC" | peeif false "tr 'B' 'Y'")
    assertFalse "peeif exits with last status" "[[ "$?" == 0 ]]"
    assertSame "" \
               "$response"
}

test_until_flag () {
    response=$(echo "ABC" | peeif -u "tr 'A' 'Z'" "tr 'B' 'Y'")
    assertSame $'ZBC' \
               "$response"

    response=$(echo "ABC" | peeif -u "false" "tr 'B' 'Y'")
    assertTrue "peeif exits with last status" "[[ "$?" == 0 ]]"
    assertSame $'AYC' \
               "$response"
}

test_no_tempfile_flag () {
    response=$(echo "ABC" | peeif -n "tr 'A' 'Z'" "tr 'B' 'Y'")
    assertSame $'ZBC\nAYC' \
               "$response"

    response=$(echo "ABC" | peeif -un "tr 'A' 'Z'" "tr 'B' 'Y'")
    assertSame $'ZBC' \
               "$response"

    response=$(echo "ABC" | peeif -un "false" "tr 'B' 'Y'")
    assertSame $'AYC' \
               "$response"
}

test_help_flag () {
    response=$(peeif -h)
    # have to eat the newline at the end
    assertSame "$(echo "$help_msg")" \
               "$response"
}

test_version_flag () {
    response=$(peeif -v)
    # have to eat the newline at the end
    assertSame "$(echo "$version_msg")" \
               "$response"
}

. shunit2

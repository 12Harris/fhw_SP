BATS_TEST_TIMEOUT=10

setup_file() {
    # sichergehen, dass $DUT gesetzt ist
    if [ -z ${DUT+x} ]; then
        echo 'DUT nicht gesetzt'
        exit
    fi

    bats_require_minimum_version 1.11.0
}

setup() {
    # zusaetzliche asserts laden
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}

teardown() {
    # Ausgabe des Aufrufs bei fehlgeschlagenen Testfaellen
    echo "Aufruf: $BATS_RUN_COMMAND"
}

@test "1.0 Hilfeaufruf, Beispieltest" {
    
    run --separate-stderr "$DUT" -h
    
    echo "$output" | diff --binary test/beispieltest/exp/usage.txt -  # nach "-h"
    [ -z "$stderr" ]  # nach "-h"
    assert_success  # nach "-h"
}

@test "2.0 Groesster gemeinsamer Teiler, Beispieltest" {

    run --separate-stderr "$DUT" 5 d 25

    assert_output '%%%The greatest common divisor of the numbers 5 and 25 is 5.%%%'
    [ -z "$stderr" ] # Es darf keine Ausgabe auf stderr geben
    assert_success
}

@test "3.0 Kleinstes gemeinsames Vielfaches, Beispieltest" {

    run --separate-stderr "$DUT" 3 m 7

    assert_output "\"'*'\"The least common multiple of the numbers 3 and 7 is 21.\"'*'\""
    [ -z "$stderr" ] # Es darf keine Ausgabe auf stderr geben
    assert_success
}

@test "4.0 Potenz von 6, Beispieltest" {

    run --separate-stderr "$DUT" 6 p 4

    assert_output '*/^\*The 4th power of the number 6 is 1296.*/^\*'
    [ -z "$stderr" ] # Es darf keine Ausgabe auf stderr geben
    assert_success
}

@test "5.0 Fehlerfall: keine Parameter, Beispieltest" {
    
    run --separate-stderr "$DUT"
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error:'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

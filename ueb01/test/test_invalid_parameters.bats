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

@test "1.0 Fehlerfall: zu viele Parameter, Beispieltest" {
    
    run --separate-stderr "$DUT" 5 d 25 7
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Wrong number of parameters.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure

    run --separate-stderr "$DUT" 5 d 25 e
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Wrong number of parameters.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

@test "2.0 Fehlerfall: zu wenig Parameter, Beispieltest" {
    
    run --separate-stderr "$DUT" 5 d
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Wrong number of parameters.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

@test "3.0 Fehlerfall: Ungültige Operanden (Linker Operand keine positive Ganzzahl), Beispieltest 1" {
    
    run --separate-stderr "$DUT" 5c d 25
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
   
    
    run --separate-stderr "$DUT" c d 25
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
    
}

@test "4.0 Fehlerfall: Ungültige Operanden (Rechter Operand keine Ganzzahl), Beispieltest 2" {
    
    run --separate-stderr "$DUT" 5 d 25e
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure

    run --separate-stderr "$DUT" 5 d e
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

@test "5.0 Fehlerfall: Ungültige Operanden (Linker Operand ist negative Ganzzahl), Beispieltest 1" {
    
    run --separate-stderr "$DUT" -5 d 25
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

@test "6.0 Fehlerfall: Ungültige Operanden (Rechter Operand ist negative Ganzzahl), Beispieltest 2" {
    
    run --separate-stderr "$DUT" 5 d -25
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Numbers must be positive integers.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}

@test "7.0 Fehlerfall: Ungültiger Operator, Beispieltest" {
    
    run --separate-stderr "$DUT" 5 u -25
    
    assert_regex "$(echo "$stderr" | head --lines=1)" '^Error: Unknown operation.'
    echo "$stderr" | tail --lines=+2 | diff --binary test/beispieltest/exp/usage.txt -
    assert_output ''
    assert_failure
}


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
    local dir
    dir="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
    load "$dir/test_helper/bats-support/load"
    load "$dir/test_helper/bats-assert/load"
}

teardown() {
    # Ausgabe des Aufrufs bei fehlgeschlagenen Testfaellen
    echo "Aufruf: $BATS_RUN_COMMAND"
}

@test "1.0 Eingabe als Oktalzahl: Beispieltest" {
    
    run --separate-stderr "$DUT" 010 d 020

    assert_output '%%%The greatest common divisor of the numbers 8 and 16 is 8.%%%'
    [ -z "$stderr" ] # Es darf keine Ausgabe auf stderr geben
    assert_success

}

@test "2.0 Eingabe als Hexadezimalzahl: Beispieltest" {
    
    run --separate-stderr "$DUT" 0xc d 0x30

    assert_output '%%%The greatest common divisor of the numbers 12 and 48 is 12.%%%'
    [ -z "$stderr" ] # Es darf keine Ausgabe auf stderr geben
    assert_success

}

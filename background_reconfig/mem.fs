hex

0 value outfile

: type ( c-addr u )
    outfile if
        outfile write-file throw
    else
        type
    then
;
: emit ( u )
    outfile if
        pad c! pad 1 outfile write-file throw
    else
        emit
    then
;
: cr ( u )
    outfile if
        s" " outfile write-line throw
    else
        cr
    then
;

: create-output-file w/o create-file throw to outfile ;

\ .mem is a memory dump formatted for use with Lattice Diamond
s" bank.mem" create-output-file
:noname
    s" #Format=AddrHex" type cr
    s" #Depth=2048" type cr
    s" #Width=16" type cr
    s" #AddrRadix=3" type cr
    s" #DataRadix=3" type cr
    s" #Data" type cr
    800 0 do
        i s>d <# # # # # #> type s"  : " type
        i s>d <# # # # # #> type cr
    1 +loop
; execute

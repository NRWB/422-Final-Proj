    ORG    $1000
START:

* THINK ABOUT ASKING FOR VALID START/END NO NEGATIVE ADDR

* ASK FOR INPUT, LOADS MSG
        LEA     MSGSTART,A1
        MOVE.B  #14,D0
        TRAP    #15
        
* GETS THE INPUT AND STORES IN D1
        MOVE.B  #4,D0
        TRAP    #15
        
* MOVE IT TO ANOTHER DATA REGISTER
*       MOVE.B  D1,D2

        MOVEA.W D1,A2
        
        MOVE.W  A2,D5

* ASK FOR INPUT, LOADS MSG
        LEA     MSGEND,A1
        MOVE.W  #14,D0
        TRAP    #15
        
* GETS THE INPUT AND STORES IN D1
        MOVE.B  #4,D0
        TRAP    #15

CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0

* Put variables and constants here

    END    START        ; last line of source


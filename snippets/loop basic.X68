CR  EQU $0D
LF  EQU $0A

    ORG    $1000

START:                  ; first instruction of program

    LEA     CSTRING, A1
    MOVE.B  #14, D0
    TRAP    #15

    ANDI.L  #0,D1 ; CLEARING EVERYTHING TO ZERO
    EOR.L   #0,D2 ; ANYTHING XOR'D WITH ITSELF ZERO'S OUT TO ZERO
    
    MOVE.B  #4, D2
        
IF_BODY:
    LEA EQUALS, A1
    MOVE.B  #14, D0
    TRAP #15
    
    ADDI    #1,D1
    CMP.B   D1,D2
    BNE     IF_BODY
    
IF_DONE:
    LEA BYE,A1
    MOVE.B  #14, D0
    TRAP #15

SIMHALT

CSTRING DC.B 'THIS IS A STRING',CR,LF,0 
EQUALS  DC.B '==',CR,LF,0
BYE     DC.B 'CIAO',CR,LF,0



* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

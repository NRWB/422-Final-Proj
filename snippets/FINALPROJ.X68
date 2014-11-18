*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* THINK ABOUT ASKING FOR VALID START/END NO NEGATIVE ADDR

* LOAD MSGSTART, ASK FOR INPUT
        LEA     MSGSTART,A1     * Load MESSAGE START
        MOVE.B  #14,D0          * Trap #14 to display message
        TRAP    #15             * Perform #14
        
* GETS THE STARTING ADDRESS
        MOVE.B  #4,D0           * Trap #4 gets an input and stores in D1
        TRAP    #15             * Perform #15
        
* MOVE IT TO ANOTHER ADDRESS REGISTER
        MOVEA.L D1,A2           * Move the user input into A2. This is the starting address.

* LOAD MSGSTART, ASK FOR INPUT
        LEA     MSGEND,A1       * Load MESSAGE END
        MOVE.W  #14,D0          * Trap #14 to display message
        TRAP    #15             * Perform #14
        
* GETS THE ENDING ADDRESS
        MOVE.B  #4,D0           * Trap #4 gets an inptu and stores in D1
        TRAP    #15             * Perform Trap #4
        MOVE.L  D1,D5           * Move the ending address into D5. This is the ending address.
        
LOOP    MOVE.W  (A2)+,D1        * Read an operation into D1        
        MOVE.B  #3,D0           * Print out what we just found
        TRAP    #15             * Perform Trap #3
        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP


CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0

* Put variables and constants here

    ORG $4000

    MOVE.B   #%10011010, D0
    MOVE.B   #%10101001, D1
    ADD.B    D0,D1

END
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

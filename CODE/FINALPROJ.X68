*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
<<<<<<< HEAD
    
START:  ORG    $1000            * first instruction of program
=======
OP_0000     EQU     %0000
OP_0001     EQU     %0001
OP_0010     EQU     %0010
OP_0011     EQU     %0011
OP_0100     EQU     %0100     
OP_0101     EQU     %0101
OP_0110     EQU     %0110
OP_0111     EQU     %0111
OP_1000     EQU     %1000
OP_1001     EQU     %1001
OP_1010     EQU     %1010
OP_1011     EQU     %1011
OP_1100     EQU     %1100
OP_1101     EQU     %1101
OP_1110     EQU     %1110
OP_1111     EQU     %1111


    ORG    $1000
START:                  ; first instruction of program
>>>>>>> origin/master

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
        
        LEA     NEWLINE,A1      * Store newline variable for seperating operations
        
LOOP    MOVE.W  (A2)+,D1        * Read an operation into D1        
        MOVE.B  #3,D0           * Print out what we just found
        TRAP    #15             * Perform Trap #3
        
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP


CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0
NEWLINE     DC.B    CR,LF,0

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

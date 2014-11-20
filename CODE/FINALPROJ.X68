*    666
*   66 66
*  66   66
*  66   66         8888
*  66   66       88   kkkk
*  66  66       8   88   kk      
*   66  6      8  88  kkk  kk    
*    66  6    8  88     kk  k
*     66 66  88 88        kk
*     6 ------- 8
*    6  68k PRO  8
*   6-------------8
*  6               8        68k is as easy as
*  6    0     0    8        6 - 8 - k !
*  6   /   V   \   8 
*  6   \__/ \__/   8        Welcome to our Dissasembler, Professor Nash!
*    6            8         Enjoy your stay!
*      6        8      
*        666888
*  _____                   __    ___  _    
* | ____|__ _ ___ _   _   / /_  ( _ )| | __
* |  _| / _` / __| | | | | '_ \ / _ \| |/ /
* | |__| (_| \__ \ |_| | | (_) | (_) |   < 
* |_____\__,_|___/\__, |  \___/ \___/|_|\_\
*                 |___/           
*-----------------------------------------------------------
* Title      : 68K Decompiler
* Written by : Nick Bell, Sammy Nimnuch, Caleb Larson
* Date       : 11/2014
* Description: This program decompiles other 68K programs
*              which are loaded into the simulator simultaneously.
*-----------------------------------------------------------


OP_0000     EQU     %0000000000000000
OP_0001     EQU     %0001000000000000
OP_0010     EQU     %0010000000000000
OP_0011     EQU     %0011000000000000
OP_0100     EQU     %0100000000000000
OP_0101     EQU     %0101000000000000
OP_0110     EQU     %0110000000000000
OP_0111     EQU     %0111000000000000
OP_1000     EQU     %1000000000000000
OP_1001     EQU     %1001000000000000
OP_1010     EQU     %1010000000000000
OP_1011     EQU     %1011000000000000
OP_1100     EQU     %1100000000000000
OP_1101     EQU     %1101000000000000
OP_1110     EQU     %1110000000000000
OP_1111     EQU     %1111000000000000

BITMASK     EQU     $F000       * used to bitmask the first nibble

START:  ORG    $1000            * first instruction of program

* -----------------------------------
* Starting and Ending Addresses
* -----------------------------------

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
        MOVE.B  #4,D0           * Trap #4 gets an input and stores in D1
        TRAP    #15             * Perform Trap #4
        MOVE.L  D1,D5           * Move the ending address into D5. This is the ending address.
        LEA     NEWLINE,A1      * Store newline variable for seperating operations
        
LOOP    
        MOVE.W  #BITMASK,D2     * Load the bitmask into data register D2
        MOVE.W  (A2)+,D1        * Read an operation into D1
        AND.W   D1,D2           * Apply this bitmask
        CMP     #OP_0100,D2     * Does the operation start with 0100?
        BNE     NEXT16          * No, check next case
        BSR     OP0100          * Branch to subroutine 0100
        BRA     ITERATION       * Move to next iteration of the loop
        
NEXT16
        MOVE.B  #3,D0           * Print out operation we don't recognize
        TRAP    #15             * Perform Trap #3
        
ITERATION
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15             * Perform Trap #14

        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP

OP0000
OP0001  * MOVE_BYTE,
OP0010  * MOVE_LONG, MOVEA_LONG
OP0011  * MOVE_WORD, MOVEA_WORD
*OP0100 -> ALREADY MADE. NO_OP, MOVEM
OP0101
OP0110
OP0111
OP1000
OP1001
OP1010
OP1011
OP1100  * MULS,
OP1101  * ADD, ADDA
OP1110
OP1111



OP0100                          * TODO: CONSIDER ALL 0100 OPERATIONS
        MOVEM   D0-D1/A0-A1,-(A7) * Push values to the stack to save
        
        LEA     NOOPERATION,A1
        
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        
        RTS

CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0
NEWLINE     DC.B    CR,LF,0
NOOPERATION DC.B    'NOP',0

 * ---------------------------------------------------------------------------
 * ---------------------------------------------------------------------------
 * Data defined constants
 *   - B/W/L (representing Byte, Word, Long)
 *   - A0-A7 (representing the 8 address registers)
 *   - D0-D7 (representing the 8 data registers)
 * ---------------------------------------------------------------------------

__B        DC.B    'B'
__W        DC.B    'W'
__L        DC.B    'L'

__A0        DC.B   'A0'
__A1        DC.B   'A1'    
__A2        DC.B   'A2'
__A3        DC.B   'A3'
__A4        DC.B   'A4'
__A5        DC.B   'A5'
__A6        DC.B   'A6'
__A7        DC.B   'A7'

__D0        DC.B   'D0'
__D1        DC.B   'D1'
__D2        DC.B   'D2'
__D3        DC.B   'D3'
__D4        DC.B   'D4'
__D5        DC.B   'D5'
__D6        DC.B   'D6'
__D7        DC.B   'D7'
 * ---------------------------------------------------------------------------
 * End of definition segment
 * ---------------------------------------------------------------------------
 * ---------------------------------------------------------------------------

* Put variables and constants here

    ORG $4000

    NOP
    MOVE.B   #%10011010, D0
    MOVE.B   #%10101001, D1
    ADD.B    D0,D1
    NOP

END
    END    START        ; last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

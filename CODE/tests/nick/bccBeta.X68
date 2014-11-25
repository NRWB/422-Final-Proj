
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

* BITMASK     EQU     $F000       * used to bitmask the first nibble

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
        MOVE.L  D1,D5           * Move the ending address into D5
        LEA     NEWLINE,A1      * Store newline variable for seper opcodes
        
        MOVE.W  #15,D7          * prep D7 for bitmask subroutine
        MOVE.W  #12,D6          * prep D6 for bitmask subroutine
        BSR     BITMASK         * obtain a bitmask that goes from 12-15 (inclusive)
        * MOVE.W  D6,D2           * move the bitmask to D2
        
LOOP    
        
        * MOVE.W  #BITMASK,D2     * Load the bitmask into data register D2
        MOVE    D6,-(A7)        * save the bitmask
        MOVE.W  (A2)+,D2        * Read an operation into D1
        AND.W   D2,D6           * Apply this bitmask
        
        CMP     #OP_0110,D6     * Does the operation start with 0100?
        BNE     NEXT16          * No, check next case
        BSR     OP0110          * Branch to subroutine 0100
        BRA     ITERATION       * Move to next iteration of the loop
        
NEXT16
        MOVE.W  D2,D1           * Print opcode we don't recognize

        MOVE.B  #3,D0           * Print out operation we don't recognize
        TRAP    #15             * Perform Trap #3
        
ITERATION
        MOVE    (A7)+,D6        * restore the bitmask to its previous state

        MOVE.B  #14,D0          * Print a newline
        TRAP    #15             * Perform Trap #14

        CMP     A2,D5           * Compare the starting address to ending address
        BGE     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP

OP0000
       
OP0001  

OP0010  

OP0011
    MOVEM   D0-D7/A0-A6, -(A7)
    
    MOVE.W  #6,D6
    MOVE.W  #8,D7
    
    BSR     BITMASK
    
    AND.W   D2,D6
    
    CMP     #%0000000001000000,D6
    BNE     NEXT15
    BSR     * for MOVEA.W
    
NEXT15

OP0100  * TODO: movem, lea, neg, jsr, rts

        MOVEM   D0-D1/A0-A1,-(A7) * Push values to the stack to save
        
        * prep values for BITMASK subroutine
        MOVE.W  #8,D6
        MOVE.W  #11,D7
        
        BSR     BITMASK
        
        AND     D2,D6                   * apply bitmask
        
        CMPI    #%0000010000000000,D6   * are we NEG?
        BNE     NEXT19                  * not neg
      
        * it is NEG, print
        LEA     NEGOP,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     NEXT17 * we found the op, move to next iteration
        
NEXT19 * is it MOVEM?

        * prep values for BITMASK subroutine
        MOVE.W  #7,D6
        MOVE.W  #9,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000010000000,D6 * is it MOVEM?
        BNE     NEXT18          * it is not MOVEM
        
        * it is MOVEM
        LEA     MOVEMOP,A1
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
        BRA     NEXT17
NEXT18
        
        LEA     NOOPERATION,A1
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
NEXT17
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS
        
OP0101



* --- OP 0110 ------------------------------------------
* FUNCTIONS     BCC, BCS, BGE, BLT, BVC, BRA
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* Description: Straight forward static bit parses
*              (ignoring prefix 0110's below)
*              BCC - 4 bits "condition", 8 bits "displacement"
*                    +++++++++++++++ Conditions Table +++++++++++++++++
*                       Condition Names  - Mnemonic - Condition Code
*                       --------------------------------------------
*                       True             -    T     - 0000
*                       False            -    F     - 0001
*                       Higher           -    HI    - 0010
*                       Lower or Same    -    LS    - 0011
*                       Carry Clear      -    CC    - 0100
*                       Carry Set        -    CS    - 0101
*                       Not Equal        -    NE    - 0110
*                       Equal            -    EQ    - 0111
*                       Overflow Clear   -    VC    - 1000
*                       Overflow Set     -    VS    - 1001
*                       Plus             -    PL    - 1010
*                       Minus            -    MI    - 1011
*                       Greater or Equal -    GE    - 1100
*                       Less Than        -    LT    - 1101
*                       Greater Than     -    GT    - 1110
*                       Less or Equal    -    LE    - 1111
*                       --------------------------------------------
*              BCS - 0101, 8 bits "displacement"
*              BGE - 1100, 8 bits "displacement"
*              BLT - 1101, 8 bits "displacement"
*              BVC - 1000, 8 bits "displacement"
*              BRA - 0000, 8 bits "displacement"
* ------------------------------------------------------
OP0110
        MOVEM       D0-D1/A0-A1,-(A7) * Save main method routine vars to stack
        
        * Ready four bits to help distinguish op's with the 0110 prefix
        MOVE.W  #0,D6                 * Move in 0 to D6 (first arg for the
                                      * BITMASK sub-routine call)
        MOVE.W  #7,D7                 * Move in 7 to D7 (second arg for the
                                      * BITMASK sub-routine call)
                                      
        * The BITMASK call uses D6 as start bit, D7 as ending bit to mask
        BSR     BITMASK               * Call BITMASK sub-routine
                                      * Returns a bitmask in D6
        
        AND     D2,D6                 * And the index op, which was pre-loaded
                                      * in the main memory loop with the bitmask
                                      * to use to determine what case we need.
        
        * Check for BCC first by seeing if the 8 bit offset is $00 or $FF.
        * Break into a case for $00 for a 16-bit displacement.
        * or, Break into a case for a $FF for a 32-bit displacement.
        * After this check is performed, then all that's left is checking
        * what mnemonic is used.
        CMPI    #%0000000000000000,D6 * if 8 bit is $00, then word off-set
        BEQ     BCC_WORD_OFFSET       * go to word off-set label
        
        CMPI    #%0000000011111111,D6 * if 8 bit is $FF, then long off-set
        BEQ     BCC_LONG_OFFSET       * go to long off-set label
        
        * passing both CMPI checks mean its a normal 8-bit offset
        * now case the remaining 16 sub ops
        
        MOVE.W  #9,D6                 * Move in 9 to D6 (first arg for the
                                      * BITMASK sub-routine call)
        MOVE.W  #11,D7                * Move in 11 to D7 (second arg for the
                                      * BITMASK sub-routine call)
                                      
        * The BITMASK call uses D6 as start bit, D7 as ending bit to mask
        BSR     BITMASK               * Call BITMASK sub-routine
                                      * Returns a bitmask in D6
        
        AND     D2,D6 
        
        * to do : convert debug print to actual output print
        CMPI    #%0000000000000000,D6 * == true
        BEQ     BCC_CONDIT_0
        CMPI    #%0000000100000000,D6 * == false
        BEQ     BCC_CONDIT_1
        CMPI    #%0000001000000000,D6 * == higher
        BEQ     BCC_CONDIT_2
        CMPI    #%0000001100000000,D6 * == Lower or Same
        BEQ     BCC_CONDIT_3
        CMPI    #%0000010000000000,D6 * == carry clear
        BEQ     BCC_CONDIT_4
        CMPI    #%0000010100000000,D6 * == carry set
        BEQ     BCC_CONDIT_5
        CMPI    #%0000011000000000,D6 * == not equal
        BEQ     BCC_CONDIT_6
        CMPI    #%0000011100000000,D6 * == equal
        BEQ     BCC_CONDIT_7
        CMPI    #%0000100000000000,D6 * Overflow Clear
        BEQ     BCC_CONDIT_8
        CMPI    #%0000100100000000,D6 * Overflow set
        BEQ     BCC_CONDIT_9
        CMPI    #%0000101000000000,D6 * plus
        BEQ     BCC_CONDIT_10
        CMPI    #%0000101100000000,D6 * minus
        BEQ     BCC_CONDIT_11
        CMPI    #%0000110000000000,D6 * Greater or Equal
        BEQ     BCC_CONDIT_12
        CMPI    #%0000110100000000,D6 * less than
        BEQ     BCC_CONDIT_13
        CMPI    #%0000111000000000,D6 * greater than
        BEQ     BCC_CONDIT_14
        CMPI    #%0000111100000000,D6 * less or equal
        BEQ     BCC_CONDIT_15
BCC_CONDIT_0
        LEA     BCC_CONDIT_0_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_1
        LEA     BCC_CONDIT_1_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_2
        LEA     BCC_CONDIT_2_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_3
        LEA     BCC_CONDIT_3_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_4
        LEA     BCC_CONDIT_4_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_5
        LEA     BCC_CONDIT_5_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_6
        LEA     BCC_CONDIT_6_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_7
        LEA     BCC_CONDIT_7_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_8
        LEA     BCC_CONDIT_8_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_9
        LEA     BCC_CONDIT_9_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_10
        LEA     BCC_CONDIT_10_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_11
        LEA     BCC_CONDIT_11_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_12
        LEA     BCC_CONDIT_12_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_13
        LEA     BCC_CONDIT_13_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_14
        LEA     BCC_CONDIT_14_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_15
        LEA     BCC_CONDIT_15_MSG,A1
        BRA     BCC_CONDIT_PRINT
BCC_CONDIT_PRINT
        MOVE.B  #14,D0
        TRAP    #15
        BRA     BCC_END  
BCC_WORD_OFFSET
        * print out the op BCC.W
        LEA     BCC_WORD,A1
        MOVE.B  #14,D0
        TRAP    #15
        * load raw word data (currently only decimal format)
        CLR.L   D5
        MOVE.W  (A2)+,D5 * test to see if this increases the main memory pointer by 16 bits
        * print out the raw data after op
        MOVE    D5,A1
        MOVE.B  #14,D0
        TRAP    #15
        * go to end of this bcc-styled sub routine op method
        BRA     BCC_END
BCC_LONG_OFFSET
        * print out the op BCC.L
        LEA     BCC_LONG,A1
        MOVE.B  #14,D0
        TRAP    #15
        * load raw long data (currently only decimal format)
        CLR.L   D5
        MOVE.L  (A2)+,D5 * test to see if this increases the main memory pointer by 32 bits
        * print out the raw data after op
        MOVE    D5,A1
        MOVE.B  #14,D0
        TRAP    #15
        * consistency to show end of op sub routine
        BRA     BCC_END
BCC_END * reload the memory, call RTS
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS

OP0111

OP1000

OP1001

OP1010

OP1011

OP1100

OP1101

OP1110

OP1111
 
BITMASK
        MOVE    D5,-(A7)    * push D5 onto the stack so we can use it to
        CLR     D5          * clear D5 so we can use it
LOOPBIT 
        BSET    D6,D5       * set the D6th bit in D5 to 1
        ADD     #1,D6       * increment D6
        
        CMP     D7,D6       * have we finished?
        BGT     BITMASKDONE * yes
        BRA     LOOPBIT     * no, iterate again
        
BITMASKDONE

        MOVE.L  D5,D6
        MOVE    (A7)+,D5    * restore D5
        RTS

CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0
NEWLINE     DC.B    CR,LF,0
NOOPERATION DC.B    'NOP',0
NEGOP       DC.B    'NEG',0
MOVEMOP     DC.B    'MOVEM',0
BCC_WORD    DC.B    'BCC.W',0 * temp debug
BCC_LONG    DC.B    'BCC.L',0 * temp debug
DATAVAR     DC.B    ',decimal #',0

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

BCC_CONDIT_0_MSG    DC.B    'True             -    T     - 0000',0
BCC_CONDIT_1_MSG    DC.B    'False            -    F     - 0001',0
BCC_CONDIT_2_MSG    DC.B    'Higher           -    HI    - 0010',0
BCC_CONDIT_3_MSG    DC.B    'Lower or Same    -    LS    - 0011',0
BCC_CONDIT_4_MSG    DC.B    'Carry Clear      -    CC    - 0100',0
BCC_CONDIT_5_MSG    DC.B    'Carry Set        -    CS    - 0101',0
BCC_CONDIT_6_MSG    DC.B    'Not Equal        -    NE    - 0110',0
BCC_CONDIT_7_MSG    DC.B    'Equal            -    EQ    - 0111',0
BCC_CONDIT_8_MSG    DC.B    'Overflow Clear   -    VC    - 1000',0
BCC_CONDIT_9_MSG    DC.B    'Overflow Set     -    VS    - 1001',0
BCC_CONDIT_10_MSG   DC.B    'Plus             -    PL    - 1010',0
BCC_CONDIT_11_MSG   DC.B    'Minus            -    MI    - 1011',0
BCC_CONDIT_12_MSG   DC.B    'Greater or Equal -    GE    - 1100',0
BCC_CONDIT_13_MSG   DC.B    'Less Than        -    LT    - 1101',0
BCC_CONDIT_14_MSG   DC.B    'Greater Than     -    GT    - 1110',0
BCC_CONDIT_15_MSG   DC.B    'Less or Equal    -    LE    - 1111',0

* Put variables and constants here

    ORG $4000

    * NOP
    BCC     END
    * MOVE.B   #%10011010, D0
    * MOVE.B   #%10101001, D1
    * ADD.B    D0,D1

END
    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

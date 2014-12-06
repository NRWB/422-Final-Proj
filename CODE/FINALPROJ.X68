*    666
*   66 66
*  66   66
*  66   66         8888
*  66   66       88   kkkk
*  66  66       8   88   kk      
*   66  6      8  88  kkk  kk    
*    66  6    8  88     kk  k
*     66 66  88 88        kk
*     6 _______ 8
*    6    68k    8
*   6_____PRO_____8
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
HEX_VALUE_MASK_LONG EQU     $0000000F  * mask a hex value in 32-bits

* BITMASK     EQU     $F000       * used to bitmask the first nibble

START:  ORG    $1000            * first instruction of program

* -----------------------------------
* Starting and Ending Addresses
* -----------------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: x
* DESCRIPTION:    a
* PRE-CONDITION:  b
* POST-CONDITION: c
* REGISTERS:      d
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------

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
        MOVE    D6,-(A7)        * save the bitmask on the stack
        MOVE.W  (A2)+,D2        * Read an operation into D1
        AND.W   D2,D6           * Apply this bitmask
        
        CMP     #OP_0000,D6     * Does the operation start with 0000?
        BNE     NOT0000         * No, check next case
        BSR     OP0000          * Branch to subroutine 0000
        BRA     ITERATION       * Move to next iteration of the loop
NOT0000        
        CMP     #OP_0001,D6     * Does the operation start with 0001?
        BNE     NOT0001         * No, check next case
        BSR     OP0001          * Branch to subroutine 0001
        BRA     ITERATION       * Move to next iteration of the loop
NOT0001
        CMP     #OP_0010,D6     * Does the operation start with 0010?
        BNE     NOT0010         * No, check next case
        BSR     OP0010          * Branch to subroutine 0010
        BRA     ITERATION       * Move to next iteration of the loop
NOT0010
        CMP     #OP_0011,D6     * Does the operation start with 0011?
        BNE     NOT0011         * No, check next case
        BSR     OP0011          * Branch to subroutine 0011
        BRA     ITERATION       * Move to next iteration of the loop
NOT0011
        CMP     #OP_0100,D6     * Does the operation start with 0100?
        BNE     NOT0100         * No, check next case
        BSR     OP0100          * Branch to subroutine 0100
        BRA     ITERATION       * Move to next iteration of the loop
NOT0100
        CMP     #OP_0101,D6     * Does the operation start with 0101?
        BNE     NOT0101         * No, check next case
        BSR     OP0101          * Branch to subroutine 0101
        BRA     ITERATION       * Move to next iteration of the loop
NOT0101
        CMP     #OP_0110,D6     * Does the operation start with 0110?
        BNE     NOT0110         * No, check next case
        BSR     OP0110          * Branch to subroutine 0110
        BRA     ITERATION       * Move to next iteration of the loop
NOT0110
        CMP     #OP_0111,D6     * Does the operation start with 0111?
        BNE     NOT0111         * No, check next case
        BSR     OP0111          * Branch to subroutine 0111
        BRA     ITERATION       * Move to next iteration of the loop
NOT0111
        CMP     #OP_1000,D6     * Does the operation start with 1000?
        BNE     NOT1000         * No, check next case
        BSR     OP1000          * Branch to subroutine 1000
        BRA     ITERATION       * Move to next iteration of the loop
NOT1000
        CMP     #OP_1001,D6     * Does the operation start with 1001?
        BNE     NOT1001         * No, check next case
        BSR     OP1001          * Branch to subroutine 1001
        BRA     ITERATION       * Move to next iteration of the loop
NOT1001
        CMP     #OP_1010,D6     * Does the operation start with 1010?
        BNE     NOT1010         * No, check next case
        BSR     OP1010          * Branch to subroutine 1010
        BRA     ITERATION       * Move to next iteration of the loop
NOT1010
        CMP     #OP_1011,D6     * Does the operation start with 1011?
        BNE     NOT1011         * No, check next case
        BSR     OP1011          * Branch to subroutine 1011
        BRA     ITERATION       * Move to next iteration of the loop
NOT1011
        CMP     #OP_1100,D6     * Does the operation start with 1100?
        BNE     NOT1100         * No, check next case
        BSR     OP1100          * Branch to subroutine 1100
        BRA     ITERATION       * Move to next iteration of the loop
NOT1100
        CMP     #OP_1101,D6     * Does the operation start with 1101?
        BNE     NOT1101         * No, check next case
        BSR     OP1101          * Branch to subroutine 1101
        BRA     ITERATION       * Move to next iteration of the loop
NOT1101
        CMP     #OP_1110,D6     * Does the operation start with 1110?
        BNE     NOT1110         * No, check next case
        BSR     OP1110          * Branch to subroutine 1110
        BRA     ITERATION       * Move to next iteration of the loop
NOT1110
        CMP     #OP_1111,D6     * Does the operation start with 1111?
        BNE     LOOPUNKNOWNOP   * No, check next case
        BSR     OP1111          * Branch to subroutine 1111
        BRA     ITERATION       * Move to next iteration of the loop
        
LOOPUNKNOWNOP
        BSR     UNKNOWNOP
        
ITERATION
        MOVE    (A7)+,D6        * restore the bitmask to its previous state

        *MOVE.B  #14,D0          * Print a newline
        *TRAP    #15             * Perform Trap #14

        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0000   (BCLR, ORI, CMPI)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0000
        MOVEM   D0-D1/A0-A1,-(A7)   * Push values to the stack to save
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000110000000, D6  * Are we BCLR?
        BNE     NOTBCLR                 * If not, branch to other OP0000 functions
        
        LEA     BCLROP,A1           * We found BCLR
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        BRA     END0000              * Found the op, move to next iteration

NOTBCLR * Possible options left are ORI or CMPI
        MOVE.W  #9, D6              * Prep lower value for bitmask
        MOVE.W  #11, D7             * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000000000, D6  * Are we ORI?
        BEQ     ISORI                   * If ORI, branch to ISORI
        
        CMPI    #%0000110000000000, D6  * Hmm... Maybe we're CMPI?
        BEQ     ISCMPI                  * If CMPI, branch to ISCMPI
        
        BNE     UNKNOWNOP               * Otherwise, this op is an imposter. 
                                        * We don't deal too kindly with imposters.
        
ISORI   * TODO
        

ISCMPI
        LEA     CMPIOP, A1          * Load 'CMPI' into the output window
        MOVE.B  #14,D0              * Trap #14 prints out the data in D0
        TRAP    #15                 * Perform Trap #14
        
        * Determine the Size
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #7, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000011000000, D6  * Imposter Op
        BEQ     UNKNOWNOP               * Deal with the imposter
        
        CMPI    #%0000000000000000, D6  * The size is a BYTE
        BEQ     CMPIBYTE                * Branch to CMPI.B
        
        CMPI    #%0000000001000000, D6  * The size is a WORD
        BEQ     CMPIWORD                * Branch to CMPI.W
        
        CMPI    #%0000000010000000, D6  * The size is a LONG
        BEQ     CMPILONG                * Branch to CMPI.L
        
CMPIBYTE
        LEA     __B, A1     * Load .B
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        LEA     IMD, A1     * Load #
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        MOVE.W  (A2)+,D3    * Advance a word forward to get the value.
        MOVE.B  D3,D1       * Move the lower byte from D3 into D1
        MOVE.W  -(A2),D3    * Now go back
        MOVE.B  #14, D0     * Print out the data
        TRAP    #15         * Perform Trap #14 
        
        BRA     CMPIEA      * Branch to determine Effective Address
        
CMPIWORD
        LEA     __W, A1     * Load .W
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        LEA     IMD, A1     * Load #
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        MOVE.W  (A2)+,D3    * Advance a word forward to get the value.
        MOVE.W  -(A2),D1    * Copy the immediate Value into D1, then go back
        MOVE.B  #14, D0     * Print out the data
        TRAP    #15         * Perform Trap #14
        
        
        BRA     CMPIEA      * Branch to determine Effective Address
        
CMPILONG
        LEA     __L, A1     * Load .L
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        LEA     IMD, A1     * Load #
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        MOVE.W  (A2)+,D3    * Advance a word forward to get the value.
        MOVE.L  -(A2),D1    * Copy the immediate value (long) into D1, then go back
        MOVE.B  #14, D0     * Print out the data
        TRAP    #15         * Perform Trap #14
        
        BRA     CMPIEA      * Branch to determine Effective Address
        
CMPIEA
        * So far the buffer is CMPI.X #Y ... Now we need to add a comma
        LEA     COMMA, A1   * Load ,
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        LEA     __L, A1     * Load .L
        MOVE.B  #14, D0     * Print out data
        TRAP    #15         * Perform Trap #14
        
        * Determine the mode
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6  * Is the Mode 001, an unsupported mode for CMPI?
        BEQ     UNKNOWNOP               * Imposter op
        
        CMPI    #%0000000000101000, D6  * Is the Mode 101, an unsupported mode?
        BEQ     UNKNOWNOP               * Imposter op
        
        CMPI    #%0000000000110000, D6  * Is the Mode 110, an unsupported mode?
        BEQ     UNKNOWNOP               * Imposter op

        CMPI    #%0000000000111000, D6  * Is the Mode 111?
        BEQ     CMPIREG                 * Further investigation is needed
        
        * will need to call the EA helpers when they are complete
        
        * Mode is verified to be valid at this point
        *CMPI    #%0000000000000000, D6  * AMode = Dn, Reg = Dn
        *BSR     MODE_DN
        
        *CMPI    #%0000000000010000, D6  * AMode = (An), Reg = An
        *BSR     MODE_AN
        
        *CMPI    #%0000000000011000, D6  * AMode = (An)+, Reg = An
        *BSR     MODE_IAN_POS
        
        *CMPI    #%0000000000000000, D6  * AMode = -(An), Reg = An
        *BSR     MODE_IAN_PRE
        
        * Reached End of CMPI. Everything has been printed out
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS
        
CMPIREG
        MOVE.W  #0, D6              * Prep lower value for bitmask
        MOVE.W  #2, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000000000, D6  * Is the Register 000?
        BEQ     CMPIREG000
        
        CMPI    #%0000000000000001, D6  * Is the Register 001?
        BEQ     CMPIREG001
        
END0000          
       MOVEM   (A7)+,D0-D1/A0-A1   * Push values to the stack to save
       RTS
       
CMPIREG000  * TODO (xxx).W for CMPI

CMPIREG001  * TODO (xxx).L for CMPI
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0001   (MOVE.B)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0001  
        MOVEM   D0-D7/A0-A1,-(A7)   * Push vales onto stack
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        * I may have fucked off this part, sorry - Caleb
        * CMPI    #%0000000001000000, D6  * Is the destination mode 001?
        * BNE     UNKNOWNOP0001                 * If so, it's unknown.
        
        LEA     MOVEOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        MOVE.W  #12, D6              * Prep lower value for bitmask
        MOVE.W  #13, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        
        BSR     SIZE67
        BSR     EAHELPER05
        
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     ENDOP0001
        *LEA     __B,A1      * Put '.B' into the window
        *MOVE.B  #14,D0      * Trap #14 to print out
        *TRAP    #15         * Perform Trap #14
        
UNKNOWNOP0001

        BSR     UNKNOWNOP
        
ENDOP0001

        MOVEM (A7)+,D0-D7/A0-A1
        RTS        
        
        * TODO: DETERMINE THE MODE AND REG FOR DESTINATION AND SOURCE
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0010   (MOVE.L, MOVEA.L)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0010

    BSR     UNKNOWNOP
    RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0011   (MOVE.W, MOVEA.W)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0011
    MOVEM   D0-D7/A0-A6, -(A7)
    
    *MOVE.W  #6,D6
    *MOVE.W  #8,D7
    
    *BSR     BITMASK
    
    *AND.W   D2,D6
    
    *CMP     #%0000000001000000,D6
    *BNE     NEXT15
    *BSR     * for MOVEA.W
    
    MOVEM   (A7)+,D0-D7/A0-A6
    
    BSR     UNKNOWNOP
    RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0100   (NOP, MOVEM, LEA, NEG, JSR, RTS)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0100  
        * TODO: lea, movem

        MOVEM   D0-D1/A0-A1,-(A7) * Push values to the stack to save
        
        *NOP
        CMPI    #%0100111001110001,D2
        BNE     NOTNOP
        
        LEA     NOOPERATION,A1
        MOVE.B  #13,D0          * Print a newline
        TRAP    #15
        
        BRA     DONE *we found it, move on to the next iteration
NOTNOP *NEG
        
        * prep values for BITMASK subroutine
        MOVE.L  #8,D6
        MOVE.L  #11,D7
        
        BSR     BITMASK
        
        AND     D2,D6                   * apply bitmask
        
        CMPI    #%0000010000000000,D6   * are we NEG?
        BNE     NOTNEG                  * not neg
        
        MOVE.L  #3,D6
        MOVE.L  #5,D7
        
        BSR     BITMASK * generate a bitmask to be used to check mode
        
        CMPI    #%0000000000001000,D6 * check to see if it is the unsupported mode
        BEQ     UNKNOWN * if it is, print print out as hex indicating bad op
        
        CMPI    #%0000000000101000,D6 * check to see if it is the unsupported mode
        BEQ     UNKNOWN * if it is, print print out as hex indicating bad op
        
        CMPI    #%0000000000110000,D6 * check to see if it is the unsupported mode
        BEQ     UNKNOWN * if it is, print print out as hex indicating bad op
      
        * it is NEG, print
        LEA     NEGOP,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     SIZE67
        
        BSR     EAHELPER05
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     DONE * we found the op, move to next iteration
        
NOTNEG *MOVEM

        * prep values for BITMASK subroutine
        MOVE.L  #7,D6
        MOVE.L  #9,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000010000000,D6 * is it MOVEM?
        BNE     NOTMOVEM          * it is not MOVEM
        
        * make sure it is a valid size and mode for MOVEM
        
        * it is MOVEM
        LEA     MOVEMOP,A1
        MOVE.B  #13,D0          * Print a newline
        TRAP    #15
        
        * probably needs its own special code for printing the rest due to uniqueness of movem
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
        BRA     DONE          * we found and printed, move on to the next iteration
        
NOTMOVEM *JSR
        * prep values for BITMASK subroutine
        MOVE.L  #6,D6
        MOVE.L  #8,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000010000000,D6
        BNE     NOTJSR          * it's not JSR
        
        LEA     JSROP,A1
        MOVE.B  #14,D0          * Print a newline and JSR
        TRAP    #15
        
        * print out where we are jumping to
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
        MOVE.L  D2,D1   * save the opcode to print
        
        MOVE.L  #16,D2  * set the base to 16
        
        MOVE.L  #15,D0  * set D0 to 15 to indicate we are converting to a different base
        TRAP    #15     * Perform Trap #15, 15 to print out mem add in hex
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
        MOVE.L  D2,D1   * save the opcode to print
        
        MOVE.L  #16,D2  * set the base to 16
        
        MOVE.L  #15,D0  * set D0 to 15 to indicate we are converting to a different base
        TRAP    #15     * Perform Trap #15, 15 to print out mem add in hex
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
        BRA     DONE          * we already found instruction, next iteration
NOTJSR *RTS

        * prep values for BITMASK subroutine
        MOVE.L  #6,D6
        MOVE.L  #8,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000001000000,D6
        BNE     NOTRTS          * it's not RTS
        
        LEA     RTSOP,A1
        MOVE.B  #13,D0          * Print a newline and RTS
        TRAP    #15
        
        BRA     DONE          * we already found instruction, next iteration
NOTRTS  *LEA
       
        * prep values for BITMASK subroutine
        MOVE.L  #6,D6
        MOVE.L  #8,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000111000000,D6
        BNE     UNKNOWN          * it's not LEA, we dont know what it is
        
        * check to make sure it is a supported mode and size
        
        LEA     LEAOP,A1
        MOVE.B  #13,D0          * Print LEA
        TRAP    #15
        
        * call EA helper
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
                
        BRA     DONE          * we already found instruction, next iteration
        
UNKNOWN *dont know what it is
        BSR     UNKNOWNOP
        
DONE
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS
        
        BRA     ITERATION
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------        
        
        

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0101   (SUBQ)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0101

    BSR     UNKNOWNOP
    RTS

* testing branching
* op op op
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0110   (BCC, BCS, BGE, BLT, BVC, BRA)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  Given the possibilties for 0110, masks the next 4 bits
*                 in the instruction and determines what the bits match to a
*                 given condition code. If the 8 bit offset is $00, or $FF,
*                 this signifies a word or long offset (for $00 and $FF
*                 respectively). The 8 bit offset is in 2's comp. form, and
*                 should be un-done, then plus or minus to the current
*                 program counter (PC) to get the actual memory label to
*                 output to console. The word offset signal eats an
*                 additional 16 bits and the long offset eats an additional
*                 32 bits. The word/long offset are for memory alignment.
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*                 A1 (output)
* CONDITIONS TABLE:
*                Condition Names  - Mnemonic - Condition Code
*                --------------------------------------------
*                True             -    T     - 0000
*                False            -    F     - 0001
*                Higher           -    HI    - 0010
*                Lower or Same    -    LS    - 0011
*                Carry Clear      -    CC    - 0100
*                Carry Set        -    CS    - 0101
*                Not Equal        -    NE    - 0110
*                Equal            -    EQ    - 0111
*                Overflow Clear   -    VC    - 1000
*                Overflow Set     -    VS    - 1001
*                Plus             -    PL    - 1010
*                Minus            -    MI    - 1011
*                Greater or Equal -    GE    - 1100
*                Less Than        -    LT    - 1101
*                Greater Than     -    GT    - 1110
*                Less or Equal    -    LE    - 1111
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
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
        
        * Analyze the 8-bit offset in the instruction for a value of $00 or $FF.
        * $00 == word offset, $FF == long offset
     ***CMPI    #%0000000000000000,D6
     ***BEQ     BCC_WORD_OFFSET * or maybe flag a mark to grab when printing...?
     ***
     ***CMPI    #%0000000011111111,D6
     ***BEQ     BCC_LONG_OFFSET * or maybe flag a mark to grab when printing...?
        
        * IF PASSED BOTH CMPI CHECKS (ABOVE),
        * THEN THERE IS A 8-BIT OFFSET (NO EXTRA GRABS FROM MEMORY)
        
        MOVE.W  #9,D6  * Move in 9 to D6 (1st arg for the BITMASK sub-routine call)
        MOVE.W  #11,D7 * Move in 11 to D7 (2nd arg for the BITMASK sub-routine call)
                                      
        * The BITMASK call uses D6 as start bit, D7 as ending bit to mask
        BSR     BITMASK * Call BITMASK sub-routine, Returns a bitmask in D6
        AND     D2,D6   * apply the BITMASK
        
        * CASE 1: BCC - BINARY FOR "CARRY CLEAR" FLAG
        CMPI    #%0000010000000000,D6
        BEQ     OP_BCC
        
        * CASE 2: BCS - BINARY FOR "CARRY SET" FLAG
        CMPI    #%0000010100000000,D6
        BEQ     OP_BCS
        
        * CASE 3: BGE - BINARY FOR "GREATER OR EQUAL" FLAG
        CMPI    #%0000110000000000,D6
        BEQ     OP_BGE
        
        * CASE 4: BLT - BINARY FOR "LESS THAN" FLAG
        CMPI    #%0000110100000000,D6
        BEQ     OP_BLT
        
        * CASE 5: BVC - BINARY FOR "OVERFLOW CLEAR" FLAG
        CMPI    #%0000100000000000,D6
        BEQ     OP_BVC
        
        * CASE 6: BRA - BINARY FOR "BRANCH ALWAYS" FLAG
        * NOTE: A branch to the immediately following instruction automatically
        *       uses the 16-bit displacement format because the 8-bit displacement
        *       field contains $00 zero offset
        * http://68k.hax.com/BRA
        * NOTE2 ---> Does this mean, there should be no checks when debugging
        *            for word/long offsets?
        CMPI    #%0000000000000000,D6
        BEQ     OP_BRA
        
        * CASE OTHER: ADDITIONAL FLAGS ALLOWED TO SIMPLY BE "RAW DATA OPS"
        ; call raw data print out sub routine

OP_BCC
        LEA     OP_BCC_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BCS
        LEA     OP_BCS_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BGE
        LEA     OP_BGE_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BLT
        LEA     OP_BLT_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BVC
        LEA     OP_BVC_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BRA
        LEA     OP_BRA_MSG,A1
        BRA     OP_BRANCHES_PRINT

* NEED TO ADD CHECK FOR EATING ANOTHER WORD/LONG
        * need to take an extra word/long offset, given $00 or $FF read from the 8-bit offset?
        * assemble output to console
OP_BRANCHES_PRINT
        MOVE.B  #14,D0 * print instruction op
        TRAP    #15
        
		LEA		DATA,A1
		MOVE.B	#14,D0 * print raw data hex of the LABEL
		TRAP	#15
		
        MOVE.B  (A2)+,D5 * move 8 bit label addr into d5 and advance main memory program pointer too
        MOVE.L  D5,A4 * ready the 8bits into a4
        LEA     (A4),A1 * ready the a4 into a1 for print
        MOVE.B  #14,D0 * print the 8bit addr
        TRAP    #15

        BRA     BCC_END

BCC_END * reload the memory, call RTS
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_0111   ()
* DESCRIPTION:    OP code 0111 is not supported. 
* PRE-CONDITION:  
* POST-CONDITION: 
* REGISTERS:
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP0111
    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1000   (DIVS, OR)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1000
        * Saving values to the stack
        MOVEM   D0-D7/A0-A1,-(A7)

        * Check if the EA Mode is 001 since both DIVS and OR do not support it
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6  * Is the mode 001, an unsupported mode?
        BEQ     UNKNOWN                 * If so, the op is not supported
        
        * Checking for DIVS
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000111000000, D6  * Are we DIVS?
        BNE     NOTDIVS                 * If not, branch to see if it's OR
        
        LEA     DIVSOP,A1           * We found DIVS
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BSR     EAHELPER611         * Print out data. TODO: DOESN'T WORK
        
        LEA     COMMA,A1            * We found DIVS
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BSR     EAHELPER05         * Print out data. TODO: DOESN'T WORK
        
        LEA     NEWLINE,A1          * We found DIVS
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
NOTDIVS * It is confirmed OR at this point
        LEA     OROP,A1         * We found OR
        MOVE.B  #14,D0          * Trap #14 prints out the data
        TRAP    #15             * Perform Trap #14
        
        BSR     EAHELPER611

OP1000END
        MOVEM   D0-D7/A0-A1,-(A7)
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1001   (SUB)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1001

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1010   ()
* DESCRIPTION:    a
* PRE-CONDITION:  b
* POST-CONDITION: c
* REGISTERS:      d
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1010

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1011   (EOR, CMP)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1011

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1100   (MULS)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1100

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1101   (ADD, ADDA)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1101

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1110   (LSL, LSR, ASL, ASR, ROL, ROR)
* DESCRIPTION:    Determines the instruction by using bit-level logic.
* PRE-CONDITION:  xyz
* POST-CONDITION: All registers return to their previous state, and the output
*                 goes to the output console for reading the raw data or the
*                 actual instruction.
* REGISTERS:      D0, D1 (output), D2 (op-code), D6 (bitmask)
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1110

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: OP_1111   ()
* DESCRIPTION:    a
* PRE-CONDITION:  b
* POST-CONDITION: c
* REGISTERS:      d
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
OP1111

    BSR     UNKNOWNOP
    RTS

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           EAHELPER611
* DESCRIPTION:    a
* PRE-CONDITION:  D2 contains the instruction to print modes for.
*                 
* POST-CONDITION: Determines mode, passes D2 to EAHELPER05 to print.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
EAHELPER611
    MOVEM  D0-D7/A0-A1,-(A7) * save stuff
    
    MOVE.W  #0, D6              * Prep lower value for bitmask
    MOVE.W  #2, D7              * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
    AND     D2,D6               * Apply bitmask
    
    CMPI    #%0000000111000000,D6 * is it immediate?
    BNE     NOTIMMEDIATE

    CMPI    #1,D3 * is it a byte?
    BNE     NOTIMMBYTE
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  #0, D6              * Prep lower value for bitmask
    MOVE.W  #7, D7              * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
        
    MOVE.W  (A2)+,D1
    
    AND     D6,D1
        
    MOVE.B  #3,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05

NOTIMMBYTE
    
    CMPI    #2,D3 * is it a word?
    BNE     NOTIMMWORD
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  #0, D6              * Prep lower value for bitmask
    MOVE.W  #15, D7             * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
        
    MOVE.W  (A2)+,D1
    
    AND     D6,D1               * Apply bitmask
        
    MOVE.B  #3,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05
    
NOTIMMWORD
    CMPI    #3,D6 * is it a long?
    BNE     NOTIMMEDIATE
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
        
    MOVE.L  (A2)+,D1
        
    MOVE.B  #3,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3
    
    MOVE.W  (A2)+,D1
        
    MOVE.B  #3,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05

    
    * to move the mode where EAHELPER50 can process it
    MOVE.L  #6,D6
    MOVE.L  #8,D7
    
    BSR     BITMASK * create bitmask
    
    AND     D2,D6   * apply bitmask
    
    CLR     D3      * prep D3 to store values
    
    MOVE.W  D6,D3   * store bitmasked value in D3
    
    LSR     #3,D3   * move bits 6-8 to 3-5
    
    * to move the register where EAHELPER50 can process it
    MOVE.L  #9,D6   *prep registers to create bitmask
    MOVE.L  #11,D7
    
    BSR     BITMASK * create bitmask
    
    AND     D2,D6   * apply bitmask
    
    CLR     D4      * prep D3 to store values
    
    MOVE.W  D6,D4   * store bitmasked value in D3
    
    LSR     #8,D4   * move bits 9-11 to 0-2
    LSR     #1,D4   * move bits 9-11 to 0-2
    
    OR.L    D4,D3   * combind the register and mode
    
    MOVE.L  D3,D2   * put the result in D2 so EAHELPER05 can process it
    
    BSR     EAHELPER05
    
    MOVEM  (A7)+,D0-D7/A0-A1 * save stuff
    
    RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           EAHELPER05
* DESCRIPTION:    a
* PRE-CONDITION:  D2 contains the instruction to print modes for. Only call
*                 this sub-routine helper for operations that only have one
*                 mode register.
* POST-CONDITION: Determines mode, passes D2 to REGHELPER to print.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
EAHELPER05
    * todo: add code for printing immediate values
    
    MOVEM   D0-D7/A0-A1,-(A7) * save stuff
    
    MOVE.L  D5,D3   * move the register containing the potential size into D3
    
    MOVE.L  #3,D6
    MOVE.L  #5,D7
    
    BSR     BITMASK * generate a bitmask to identify the mode
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
    MOVE.L  D6,D5   * store the 3-5 bitmask for later use
    
    CMPI    #%0000000000000000,D6 * is it data register direct?
    BNE     NOTDATAREG
    
    BSR     MODE_DN
     
    BRA     ENDEAHELPER05
    
NOTDATAREG * address register direct
    
    CMPI    #%0000000000001000,D6 * is it address register direct?
    BNE     NOTADRDIRECT
    
    BSR     MODE_AN * simply prints out the address register
     
    BRA     ENDEAHELPER05
    
NOTADRDIRECT * address register indirect
        
    CMPI    #%0000000000010000,D6 * is it address register indirect?
    BNE     NOTADRINDIRECT
    
    LEA     OBRACK,A1       * Load '('
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
        

    BSR     MODE_AN * print out an address register
    
    LEA     CBRACK,A1       * Load ')'
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
     
    BRA     ENDEAHELPER05
    
NOTADRINDIRECT * address register indirect, post increment
    
    CMPI    #%0000000000011000,D6 * is it address register indirect post increment?
    BNE     NOTADRINDIRECTPOST
    
    LEA     OBRACK,A1       * Load '('
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
        

    BSR     MODE_AN * print out an address register
    
    LEA     CBRACK,A1       * Load ')'
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
    
    LEA     PLUS,A1       * Load '+'
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
     
    BRA     ENDEAHELPER05
    
NOTADRINDIRECTPOST * address register indirect, pre decrement
    
    CMPI    #%0000000000100000,D6 * is it address register indirect pre decrement?
    BNE     NOTADRINDIRECTPRE
    
    LEA     MINUS,A1       * Load '-'
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
    
    LEA     OBRACK,A1       * Load '('
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
        

    BSR     MODE_AN * print out an address register
    
    LEA     CBRACK,A1       * Load ')'
    MOVE.W  #14,D0          * Trap #14 to display message
    TRAP    #15             * Perform #14
     
    BRA     ENDEAHELPER05

NOTADRINDIRECTPRE * if none of the previous cases are true, it is a mode not supported by our decompiler

    BSR     UNKNOWNOP
    
ENDEAHELPER05
    MOVEM   (A7)+,D0-D7/A0-A1 * restore stuff
    RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           MODE_DN
* DESCRIPTION:    Generalize the EA part of the project.
* PRE-CONDITION:  The mode must have been correctly identified. All modes
*                 must be called by RTS.
* POST-CONDITION: After the EA, the entire op will head back to the BSR that
*                 called it.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
* ---> Dn
MODE_DN
        MOVEM   D0-D7/A0-A1,-(A7) * save stuff

        MOVE.W  #0, D6              * Prep lower value for bitmask
        MOVE.W  #2, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%000000000000000, D6   * Data Register D0?
        BNE     NOTD0
        
        BSR     PRINTD0
        BRA     ENDMODE_DN
NOTD0      
        CMPI    #%000000000000001, D6   * Data Register D1?
        BNE     NOTD1
        
        BSR     PRINTD1
        BRA     ENDMODE_DN
NOTD1
        CMPI    #%000000000000010, D6   * Data Register D2?
        BNE     NOTD2
        
        BSR     PRINTD2
        BRA     ENDMODE_DN
NOTD2
        CMPI    #%000000000000011, D6   * Data Register D3?
        BNE     NOTD3
        
        BSR     PRINTD3
        BRA     ENDMODE_DN
NOTD3
        CMPI    #%000000000000100, D6   * Data Register D4?
        BNE     NOTD4
        
        BSR     PRINTD4
        BRA     ENDMODE_DN
NOTD4
        CMPI    #%000000000000101, D6   * Data Register D5?
        BNE     NOTD5
        
        BSR     PRINTD5
        BRA     ENDMODE_DN
NOTD5
        CMPI    #%000000000000110, D6   * Data Register D6?
        BNE     NOTD6
        
        BSR     PRINTD6
        BRA     ENDMODE_DN
NOTD6
        BSR     PRINTD7
        BRA     ENDMODE_DN
        
ENDMODE_DN
        MOVEM   (A7)+,D0-D7/A0-A1 * restore stuff
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           PRINTD0
* DESCRIPTION:    Simply prints D0, D1, ..., up to D7.
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINTD0
        LEA     __D0, A1        * Load 'D0'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS
PRINTD1
        LEA     __D1, A1        * Load 'D1'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS      
PRINTD2
        LEA     __D2, A1        * Load 'D2'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS      
PRINTD3
        LEA     __D3, A1        * Load 'D3'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS      
PRINTD4
        LEA     __D4, A1        * Load 'D4'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS       
PRINTD5
        LEA     __D5, A1        * Load 'D5'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS      
PRINTD6
        LEA     __D6, A1        * Load 'D6'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS
PRINTD7
        LEA     __D7, A1        * Load 'D7'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           MODE_AN
* DESCRIPTION:    Simply chooses to print A0-A7.
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
MODE_AN
        MOVEM   D0-D7/A0-A1,-(A7)   * Save information

        MOVE.W  #0, D6              * Prep lower value for bitmask
        MOVE.W  #2, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%000000000000000, D6   * Address Register A0?
        BNE     NOTA0
        
        BSR     PRINTA0
        
        BRA     ENDMODE_AN
NOTA0      
        CMPI    #%000000000000001, D6   * Address Register A1?
        BNE     NOTA1
        
        BSR     PRINTA1
        
        BRA     ENDMODE_AN
NOTA1
        CMPI    #%000000000000010, D6   * Address Register A2?
        BNE     NOTA2
        
        BSR     PRINTA2
        
        BRA     ENDMODE_AN
NOTA2
        CMPI    #%000000000000011, D6   * Address Register A3?
        BNE     NOTA3
        
        BSR     PRINTA3
        
        BRA     ENDMODE_AN
NOTA3
        CMPI    #%000000000000100, D6   * Address Register A4?
        BNE     NOTA4
        
        BSR     PRINTA4
        
        BRA     ENDMODE_AN
NOTA4
        CMPI    #%000000000000101, D6   * Address Register A5?
        BNE     NOTA5
        
        BSR     PRINTA5
        
        BRA     ENDMODE_AN
NOTA5
        CMPI    #%000000000000110, D6   * Address Register A6?
        BNE     NOTA6
        
        BSR     PRINTA6
        
        BRA     ENDMODE_AN
NOTA6
        BSR     PRINTA7
        
        BRA     ENDMODE_AN
ENDMODE_AN
        MOVEM   (A7)+,D0-D7/A0-A1   * Restore registers
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           PRINTA0
* DESCRIPTION:    Simply print out the address register.
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINTA0
        LEA     __A0, A1        * Load 'A0'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA1
        LEA     __A1, A1        * Load 'A1'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS
        
PRINTA2
        LEA     __A2, A1        * Load 'A2'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA3
        LEA     __A3, A1        * Load 'A3'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA4
        LEA     __A4, A1        * Load 'A4'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA5
        LEA     __A5, A1        * Load 'A5'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA6
        LEA     __A6, A1        * Load 'A6'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS

PRINTA7
        LEA     __A7, A1        * Load 'A7'
        MOVE.B  #14, D0         * Load Trap #14 to print out
        TRAP    #15             * Perform Trap #14
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           SIZE67
* DESCRIPTION:    Called if the size is stored in bits 6 to 7.
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
SIZE67
        MOVEM   D0-D7/A0-A6, -(A7)  * Save values to return to original when done
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #7, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask     

        CMPI    #%0000000000000000, D6   * is it a BYTE?
        BNE     NOT67BYTE
        
        BSR     PRINTBYTE               * Branch to handle BYTE sizes
        BRA     END67
NOT67BYTE        
        CMPI    #%0000000001000000, D6   * is it a WORD?
        BNE     NOT67WORD
        
        BSR     PRINTWORD               * Branch to handle WORD sizes
        BRA     END67
NOT67WORD
        CMPI    #%0000000010000000, D6   * is it a LONG?
        BNE     END67
        
        BSR     PRINTLONG               * Branch to handle LONG sizes
END67
        MOVEM   (A7)+,D0-D7/A0-A6       * Pop off the stack to return our registers
        RTS                             * Return. Size handling is finished.
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           SIZE68
* DESCRIPTION:    Called if the size is stored in bits 6 to 8.
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
SIZE68
        * finish later, need to follow the same format as SIZE67
        
        
        MOVEM   D0-D7/A0-A6, -(A7)  * Save values to return to original when done
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask          
        
        CMPI    #%0000000000000000, D6   * is it a BYTE?
        BSR     PRINTBYTE               * Branch to handle BYTE sizes
        CMPI    #%0000000100000000, D6   * is it a BYTE?
        BSR     PRINTBYTE               * Branch to handle BYTE sizes 
      
        CMPI    #%0000000001000000, D6   * is it a WORD?
        BSR     PRINTWORD               * Branch to handle BYTE sizes
        CMPI    #%0000000101000000, D6   * is it a WORD?
        BSR     PRINTWORD               * Branch to handle BYTE sizes
        CMPI    #%0000000011000000, D6   * is it a WORD (ADDA)?
        BSR     PRINTWORD               * Branch to handle BYTE sizes

        CMPI    #%0000000010000000, D6   * is it a LONG?
        BSR     PRINTLONG               * Branch to handle BYTE sizes
        CMPI    #%0000000110000000, D6   * is it a LONG?
        BSR     PRINTLONG               * Branch to handle BYTE sizes
        CMPI    #%0000000111000000, D6   * is it a LONG (ADDA)?
        BSR     PRINTLONG               * Branch to handle BYTE sizes

        MOVEM   (A7)+,D0-D7/A0-A6       * Pop off the stack to return our registers
        RTS                             * Return. Size handling is finished.
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           PRINTBYTE
* DESCRIPTION:    a
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINTBYTE
        LEA     __B,A1      * Load '.B ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68
        
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           PRINTWORD
* DESCRIPTION:    a
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINTWORD
        LEA     __W,A1      * Load '.W ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68
        
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           PRINTLONG
* DESCRIPTION:    a
* PRE-CONDITION:  a
* POST-CONDITION: a
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINTLONG
        LEA     __L,A1      * Load '.L ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68
        
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           UNKNOWNOP
* DESCRIPTION:    a
* PRE-CONDITION:  D2 contains the instruction to print. D2 has already been
*                 identified as an unknown operation.
* POST-CONDITION: D2 is no longer the opcode.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
UNKNOWNOP
        MOVE.L  A2,D1   * prep the add to print
        
        SUB.L   #2,D1   * off by two error due to post increment correct
        
        MOVE.L  D2,D3   * save the opcode to print
        
        MOVE.L  #16,D2  * set the base to 16
        
        MOVE.L  #15,D0  * set D0 to 15 to indicate we are converting to a different base
        TRAP    #15     * Perform Trap #15, 15 to print out mem add in hex
        
        LEA     DATA,A1 * load " DATA $" into register A1
        MOVE.L  #14,D0  * print the string stored in A1
        TRAP    #15
        
        MOVE.L  D3,D1   * move the opcode from D3 into D1 to print
        
        MOVE.B  #15,D0   * Indicate we are using trap #15, 15 to in a certain #base
        TRAP    #15      * Perform Trap #3

        LEA     NEWLINE,A1 * load newline into register A1
        MOVE.L  #14,D0  * print the string stored in A1
        TRAP    #15

        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: Print ASCII hex char
* DESCRIPTION:    Prints and addres register to console in hex (ASCII chars)
* PRE-CONDITION:  A6 contains the register for memory to print.
*                 This parameter would be pre-loaded by, for example:
*                 "LEA FOO_BAR_ADDR,A6" or "LEA $1234FEED,A6"
*                 D6 contains the loops to do (number of bytes).
* POST-CONDITION: 
* REGISTERS:      
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINT_ASCII_HEX_CHAR
    MOVEM.L     D0-D7/A0-A5,-(A7) * push data to save
    CLR.L       D5
    
    * fence post check (if-statement, check if 0 > chars)
    CMPI.B      #0,D6
    BEQ         INVALID_ASCII_INPUT * go to very last part if invalid
    
*    MOVE.L      A6,D4
    MOVE.L      A6,D7
PRINT_ASCII_LOOP
*    MOVE.L      A6,D7 * increase a6's pointer position ea. loop
*    MOVE.L      D4,D7 * make a mutable copy
    ROL.L       #4,D7 * roll to next spot
    MOVEM.L     D7,-(A7) * save D7

    ANDI.L      #HEX_VALUE_MASK_LONG,D7
    
    CMPI.L      #0,D7
    BLT         INVALID_ASCII_INPUT

    CMPI.L      #15,D7
    BGT         INVALID_ASCII_INPUT

    * this might be faster... to do later, after entire assignment done
     * CMPI.L      #9,D7
     * BLE         PRINT_ASCII_0_TO_9

    CMPI.L      #0,D7
    BEQ         PRINT_ASCII_0
    CMPI.L      #1,D7
    BEQ         PRINT_ASCII_1
    CMPI.L      #2,D7
    BEQ         PRINT_ASCII_2
    CMPI.L      #3,D7
    BEQ         PRINT_ASCII_3
    CMPI.L      #4,D7
    BEQ         PRINT_ASCII_4
    CMPI.L      #5,D7
    BEQ         PRINT_ASCII_5
    CMPI.L      #6,D7
    BEQ         PRINT_ASCII_6
    CMPI.L      #7,D7
    BEQ         PRINT_ASCII_7
    CMPI.L      #8,D7
    BEQ         PRINT_ASCII_8
    CMPI.L      #9,D7
    BEQ         PRINT_ASCII_9
    CMPI.L      #10,D7
    BEQ         PRINT_ASCII_A
    CMPI.L      #11,D7
    BEQ         PRINT_ASCII_B
    CMPI.L      #12,D7
    BEQ         PRINT_ASCII_C
    CMPI.L      #13,D7
    BEQ         PRINT_ASCII_D
    CMPI.L      #14,D7
    BEQ         PRINT_ASCII_E
    CMPI.L      #15,D7
    BEQ         PRINT_ASCII_F
PRINT_ASCII_0
    LEA         ASCII_0,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_1
    LEA         ASCII_1,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_2
    LEA         ASCII_2,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_3
    LEA         ASCII_3,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_4
    LEA         ASCII_4,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_5
    LEA         ASCII_5,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_6
    LEA         ASCII_6,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_7
    LEA         ASCII_7,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_8
    LEA         ASCII_8,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_9
    LEA         ASCII_9,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_A
    LEA         ASCII_A,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_B
    LEA         ASCII_B,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_C
    LEA         ASCII_C,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_D
    LEA         ASCII_D,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_E
    LEA         ASCII_E,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_F
    LEA         ASCII_F,A1
    BRA         PRINT_ASCII_CHAR
PRINT_ASCII_CHAR
    MOVE.B      #14,D0
    TRAP        #15
    
    ADD.B       #1,D5 * loop until counter stops
    CMP.B       D6,D5
    BGE         PRINT_ASCII_FINISH
    
    CLR.L       D7
    MOVEM.L     (A7)+,D7 * copy back D7 from stack, to mutate its' bits
    
    BRA         PRINT_ASCII_LOOP
INVALID_ASCII_INPUT
PRINT_ASCII_FINISH
    MOVEM.L     (A7)+,D0-D7/A0-A5 * pop saved memory
    RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: Bitmask
* DESCRIPTION:    Masks bits in a data register.
* PRE-CONDITION:  D6 contains the starting bit to be masked, and D7 contains
*                 the ending bit.  For example, a starting bit of decimal
*                 value 0 and an ending bit of decimal value 3 will mask the
*                 bits 0, 1, 2, and 3.
* POST-CONDITION: D6 contains the bitmask, ready for use.
* REGISTERS:      D5,D6,D7
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
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
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* SECTION: Constants/variables used throughout the program.
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
* ---> GENERAL
CR          EQU     $0D
LF          EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0
NEWLINE     DC.B    CR,LF,0
* ---> OPS
DIVSOP      DC.B    'DIVS',0
NOOPERATION DC.B    'NOP',0
NEGOP       DC.B    'NEG',0
MOVEOP      DC.B    'MOVE',0
MOVEMOP     DC.B    'MOVEM',0
JSROP       DC.B    'JSR',0
RTSOP       DC.B    'RTS',0
LEAOP       DC.B    'LEA',0
BCLROP      DC.B    'BCLR ',0
OROP        DC.B    'OR',0
ORIOP       DC.B    'ORI',0
CMPIOP      DC.B    'CMPI',0
DATA        DC.B    ' DATA $',0
OP_BCC_MSG  DC.B    'BCC ',0
OP_BCS_MSG  DC.B    'BCS ',0
OP_BGE_MSG  DC.B    'BGE ',0
OP_BLT_MSG  DC.B    'BLT ',0
OP_BVC_MSG  DC.B    'BVC ',0
OP_BRA_MSG  DC.B    'BRA ',0
* ---> HEX CHARS
ASCII_0     DC.B    '0',0
ASCII_1     DC.B    '1',0
ASCII_2     DC.B    '2',0
ASCII_3     DC.B    '3',0
ASCII_4     DC.B    '4',0
ASCII_5     DC.B    '5',0
ASCII_6     DC.B    '6',0
ASCII_7     DC.B    '7',0
ASCII_8     DC.B    '8',0
ASCII_9     DC.B    '9',0
ASCII_A     DC.B    'A',0
ASCII_B     DC.B    'B',0
ASCII_C     DC.B    'C',0
ASCII_D     DC.B    'D',0
ASCII_E     DC.B    'E',0
ASCII_F     DC.B    'F',0
* ---> SPECIAL CHARACTERS
SPACE       DC.B    ' ',0
DOLLAR      DC.B    '$',0
IMD         DC.B    '#',0
COMMA       DC.B    ',',0
OBRACK      DC.B    '(',0
CBRACK      DC.B    ')',0
PLUS        DC.B    '+',0
MINUS       DC.B    '-',0
* ---> B/W/L (BYTE, WORD, LONG, RESPECTIVELY)
__B         DC.B    '.B ',0
__W         DC.B    '.W ',0
__L         DC.B    '.L ',0
* ---> ADDRESS REGISTERS A0-A7
__A0        DC.B   'A0',0
__A1        DC.B   'A1',0    
__A2        DC.B   'A2',0
__A3        DC.B   'A3',0
__A4        DC.B   'A4',0
__A5        DC.B   'A5',0
__A6        DC.B   'A6',0
__A7        DC.B   'A7',0
* ---> DATA REGISTERS D0-D7
__D0        DC.B   'D0',0
__D1        DC.B   'D1',0
__D2        DC.B   'D2',0
__D3        DC.B   'D3',0
__D4        DC.B   'D4',0
__D5        DC.B   'D5',0
__D6        DC.B   'D6',0
__D7        DC.B   'D7',0
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* SECTION: Sample program to run, then attempt testing disassembly on.
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
    ORG $4000

    NOP
    MOVE.B   #%10011010, D0
    MOVE.B   #%10101001, D1
    ADD.B    D0,D1
    MOVEM    D1,-(A7)
    LEA      JSROP,A1
    NEG.W    -(A7)
    JSR      END
    DIVS    #1, D0

END
    RTS
RLLYEND
    END    START

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

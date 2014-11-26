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
        
        CMP     #OP_0100,D6     * Does the operation start with 0100?
        BNE     NEXT            * No, check next case
        BRA     OP0100          * Branch to subroutine 0100
        *BRA     ITERATION       * Move to next iteration of the loop
        
NEXT
        BRA     UNKNOWNOP
        
ITERATION
        MOVE    (A7)+,D6        * restore the bitmask to its previous state

        *MOVE.B  #14,D0          * Print a newline
        *TRAP    #15             * Perform Trap #14

        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP

* --- OP 0000 ------------------------------------------
* FUNCTIONS     BCLR, ORI, CMPI
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask. 
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
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
        BRA     DONE              * Found the op, move to next iteration

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
        
        * Mode is verified to be valid at this point
        CMPI    #%0000000000000000, D6  * AMode = Dn, Reg = Dn
        BSR     MODE_DN
        
        CMPI    #%0000000000010000, D6  * AMode = (An), Reg = An
        BSR     MODE_IAN
        
        CMPI    #%0000000000011000, D6  * AMode = (An)+, Reg = An
        BSR     MODE_IAN_POS
        
        CMPI    #%0000000000000000, D6  * AMode = -(An), Reg = An
        BSR     MODE_IAN_PRE
        
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
          

CMPIREG000  * TODO (xxx).W for CMPI

CMPIREG001  * TODO (xxx).L for CMPI
        
* --- Effective Address --------------------------------
* PURPOSE       To generalize the EA part of the project.
* PRE CON       The Mode must have been correctly identified. All Modes must be called by RTS
* POST CON      After the EA, the entire op will head back to the BSR that called it.
* ------------------------------------------------------        
MODE_DN
        MOVE.W  #0, D6              * Prep lower value for bitmask
        MOVE.W  #2, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%000000000000000, D6   * Data Register D0?
        BSR     PRINTD0
        CMPI    #%000000000000001, D6   * Data Register D1?
        BSR     PRINTD1
        CMPI    #%000000000000010, D6   * Data Register D2?
        BSR     PRINTD2
        CMPI    #%000000000000011, D6   * Data Register D3?
        BSR     PRINTD3
        CMPI    #%000000000000100, D6   * Data Register D4?
        BSR     PRINTD4
        CMPI    #%000000000000101, D6   * Data Register D5?
        BSR     PRINTD5
        CMPI    #%000000000000110, D6   * Data Register D6?
        BSR     PRINTD6
        CMPI    #%000000000000111, D6   * Data Register D7?
        BSR     PRINTD7
        
        RTS     * Return to function to handle pointer advancing, RTS to main, etc.

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
        
MODE_AN

MODE_IAN
MODE_IAN_POS
MODE_IAN_PRE

* --- OP 0001 ------------------------------------------
* FUNCTIONS     MOVE.B
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0001  




* --- OP 0010 ------------------------------------------
* FUNCTIONS     MOVE.L, MOVEA.L,
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0010  


* --- OP 0011 ------------------------------------------
* FUNCTIONS     MOVE.W, MOVEA.W
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0011
    MOVEM   D0-D7/A0-A6, -(A7)
    
    MOVE.W  #6,D6
    MOVE.W  #8,D7
    
    BSR     BITMASK
    
    AND.W   D2,D6
    
    CMP     #%0000000001000000,D6
    *BNE     NEXT15
    BSR     * for MOVEA.W


* --- OP 0100 ------------------------------------------
* FUNCTIONS     NO_OP, MOVEM, LEA, NEG, JSR, RTS
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0100  * TODO: lea, jsr, rts

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
      
        * it is NEG, print
        LEA     NEGOP,A1
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
        
        * it is MOVEM
        LEA     MOVEMOP,A1
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
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
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
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
        MOVE.B  #14,D0          * Print a newline and RTS
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
        
        LEA     LEAOP,A1
        MOVE.B  #14,D0          * Print a newline and LEA
        TRAP    #15
        
        MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
                
        BRA     DONE          * we already found instruction, next iteration
        
UNKNOWN *dont know what it is
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        BRA     UNKNOWNOP
        
DONE
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        BRA     ITERATION
        
        
        

* --- OP 0101 ------------------------------------------
* FUNCTIONS     SUBQ
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0101



* --- OP 0110 ------------------------------------------
* FUNCTIONS     BCC, BCS, BGE, BLT, BVC, BRA
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0110




* --- OP 0111 ------------------------------------------
* FUNCTIONS     
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0111



* --- OP 1000 ------------------------------------------
* FUNCTIONS     DIVS, OR
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1000



* --- OP 1001 ------------------------------------------
* FUNCTIONS     SUB
* DATA REG      D0, D1 for output. D2 for entire instruction. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1001



* --- OP 1010 ------------------------------------------
* FUNCTIONS     
* DATA REG      D0, D1 for output. D2 for entire instruction. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1010


* --- OP 1011 ------------------------------------------
* FUNCTIONS     EOR, CMP 
* DATA REG      D0, D1 for output. D2 for entire opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1011


* --- OP 1100 ------------------------------------------
* FUNCTIONS     MULS
* DATA REG      D0, D1 for output. D2 for entire opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1100



* --- OP 1101 ------------------------------------------
* FUNCTIONS     ADD, ADDA,
* DATA REG      D0, D1 for output. D2 for entire opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1101



* --- OP 1110 ------------------------------------------
* FUNCTIONS     LSL, LSR, ASL, ASR, ROL, ROR, 
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1110




* --- OP 1111 ------------------------------------------
* FUNCTIONS     
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP1111


* --- UNKNOWNOP ----------------------------------------
* PRE  COND     D2 contains the instruction we wish to print 
* POST COND     D2 is no longer the opcode
* ------------------------------------------------------
   
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
        
        BRA     ITERATION * done with this op, move on to the next iteration

 * --- BITMASK ----------------------------------------------------------------
 *@pre      D6 contains the starting bit you want masked, D7 the ending bit
 *
 *@post     D6 contains the bitmask, ready for use
 
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
        
 * --- OP0100 -----------------------------------------------------------------
 * @pre      D2 contains the opcode
 *
 * @post     all registers are returned to their previous state



 * ----------------------------------------------------------------------------
 * ----------------------------------------------------------------------------
 * Constants for printing information to the console

CR      EQU     $0D
LF      EQU     $0A
MSGSTART    DC.B    'ENTER START ADDRESS: ',CR,LF,0
MSGEND      DC.B    'ENTER END ADDRESS: ',CR,LF,0
NEWLINE     DC.B    CR,LF,0
NOOPERATION DC.B    'NOP',0
NEGOP       DC.B    'NEG',0
MOVEMOP     DC.B    'MOVEM',0
JSROP       DC.B    'JSR',0
RTSOP       DC.B    'RTS',0
LEAOP       DC.B    'LEA',0
BCLROP      DC.B    'BCLR',0
ORIOP       DC.B    'ORI',0
CMPIOP      DC.B    'CMPI',0
DATA        DC.B    ' DATA $',0

 * ----------------------------------------------------------------------------
 * ----------------------------------------------------------------------------
 * Data defined constants
 *   - B/W/L (representing Byte, Word, Long)
 *   - A0-A7 (representing the 8 address registers)
 *   - D0-D7 (representing the 8 data registers)
 * ----------------------------------------------------------------------------

IMD        DC.B    '#'
COMMA      DC.B    ','
__B        DC.B    'B '
__W        DC.B    'W '
__L        DC.B    'L '

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
    MOVEM    D1,-(A7)
    LEA      JSROP,A1
    NEG.W    D3
    JSR      END

END
    RTS
RLLYEND
    END    START        ; last line of source






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

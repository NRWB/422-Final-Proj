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
        MOVE    D6,-(A7)        * save the bitmask on the stack
        MOVE.W  (A2)+,D2        * Read an operation into D1
        AND.W   D2,D6           * Apply this bitmask
        
        CMP     #OP_0100,D6     * Does the operation start with 0100?
        BNE     NEXT            * No, check next case
        BRA     OP0100          * Branch to subroutine 0100
        *BRA     ITERATION       * Move to next iteration of the loop
        
NEXT
        BSR     UNKNOWNOP
        
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
          

CMPIREG000  * TODO (xxx).W for CMPI

CMPIREG001  * TODO (xxx).L for CMPI
        


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
OP0100  * TODO: lea, movem, neg?

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
        BRA     ITERATION
        
        
        

* --- OP 0101 ------------------------------------------
* FUNCTIONS     SUBQ
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
OP0101
* testing branching
* op op op



* --- OP 0110 ------------------------------------------
* FUNCTIONS     BCC, BCS, BGE, BLT, BVC, BRA
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG        
* POST COND     All registers return to their previous state.
* ------------------------------------------------------
* --- OP 0110 ------------------------------------------
* FUNCTIONS     BCC, BCS, BGE, BLT, BVC, BRA
* DATA REG      D0, D1 for output. D2 for opcode. D6 for bitmask.
* ADDR REG      A1 - Printing
* POST COND     All registers return to their previous state.
* Description: Determine the opcode given 0110 from matching cases.
*              Use additional word/long offset if specified to align memory evenly.
*              Perform 2's compliment on label, then output result.
*              - Conditions Table
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



* --- EAHELPER611 ----------------------------------------
* PRE  COND     D2 contains the instruction we wish to 
*               print the modes, registers for.
* POST COND     Determines mode, passes D2 to EAHELPER05 to print
* ------------------------------------------------------
EAHELPER611
    MOVEM  D0-D7/A0-A1,-(A7) * save stuff
    
    * to move the mode where EAHELPER50 can process it
    MOVE.L  #6,D6   *prep registers to create bitmask
    MOVE.L  #8,D7
    
    BSR     BITMASK * create bitmask
    
    AND     D2,D6   * apply bitmask
    
    CLR     D3      * prep D3 to store values
    
    MOVE.W  D6,D3   * store bitmasked value in D3
    
    LSL     #3,D3   * move bits 6-8 to 3-5
    
    * to move the register where EAHELPER50 can process it
    MOVE.L  #9,D6   *prep registers to create bitmask
    MOVE.L  #11,D7
    
    BSR     BITMASK * create bitmask
    
    AND     D2,D6   * apply bitmask
    
    CLR     D4      * prep D3 to store values
    
    MOVE.W  D6,D4   * store bitmasked value in D3
    
    LSL     #8,D4   * move bits 9-11 to 0-2
    LSL     #1,D4   * move bits 9-11 to 0-2
    
    OR.L    D4,D3   * combind the register and mode
    
    MOVE.L  D3,D2   * put the result in D2 so EAHELPER05 can process it
    
    BSR     EAHELPER05
    
    MOVEM  (A7)+,D0-D7/A0-A1 * save stuff
    
    RTS
    
* --- EAHELPER05 ----------------------------------------
* PRE  COND     D2 contains the instruction we wish to 
*               print the modes, registers for.
*               Only call this helper for operations that only
*               have one mode, register.
* POST COND     Determines mode, passes D2 to REGHELPER to print
* ------------------------------------------------------
*todo: add code for printing immediate values
EAHELPER05
    
    MOVEM   D0-D7/A0-A1,-(A7) * save stuff
    
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

    MOVE.L  D5,D6   * reload the bitmask into D6
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
    CMPI    #%0000000000001000,D6 * is it address register direct?
    BNE     NOTADRDIRECT
    
    BSR     MODE_AN * simply prints out the address register
     
    BRA     ENDEAHELPER05
    
NOTADRDIRECT * address register indirect
        
    MOVE.L  D5,D6   * reload the bitmask into D6
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
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
            
    MOVE.L  D5,D6   * reload the bitmask into D6
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
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

    MOVE.L  D5,D6   * reload the bitmask into D6
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
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
    
NOTADRINDIRECTPRE * immediate
    
    MOVE.L  D5,D6   * reload the bitmask into D6
    
    AND     D2,D6   * mask off the parts of D2 we don't need
    
    CMPI    #%0000000000111000,D6 * is it immediate?
    BNE     NOTIMMEDIATE

    MOVE.W  #6, D6              * Prep lower value for bitmask
    MOVE.W  #7, D7              * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
    AND     D2,D6               * Apply bitmask  

    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
        
    MOVE.W  (A2)+,D2
    
    MOVE.W  D2,D1
    
    MOVE.W  #16,D2
        
    MOVE.B  #15,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3

    MOVE.W  D3,D2
    
    BRA     ENDEAHELPER05
    
NOTIMMEDIATE * if none of the previous cases are true, it is a mode not supported by our decompiler

    BSR     UNKNOWNOP
    
ENDEAHELPER05
    MOVEM   (A7)+,D0-D7/A0-A1 * restore stuff
    RTS

* --- Effective Address --------------------------------
* PURPOSE       To generalize the EA part of the project.
* PRE CON       The Mode must have been correctly identified. All Modes must be called by RTS
* POST CON      After the EA, the entire op will head back to the BSR that called it.
* ------------------------------------------------------    

* --- Dn ---------------------------------------------------------    
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

*--- PRINTD0 ---------------------------------------
*   Simply prints D0|D1...|D7
*---------------------------------------------------
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

* --- MODE_AN ----------------------------------------------------
*   Simply chooses to print A0-A7
* ----------------------------------------------------------------
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
        
* --- Printing out Address Registers -------------------------
*   Simply print out the address register
* ------------------------------------------------------------
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
*--- SIZE67 ---------------------------------------
*   Called if the size is stored in bits 6->7
*---------------------------------------------------
        
SIZE67  * If the size is stored in bits 6->7
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

* finish later, need to follow the same format as SIZE67        
SIZE68  * If the size is stored in bits 6->8 
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
        
PRINTBYTE
        LEA     __B,A1      * Load '.B ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68
        
PRINTWORD
        LEA     __W,A1      * Load '.W ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68

PRINTLONG
        LEA     __L,A1      * Load '.L ' into A1
        MOVE.B  #14,D0      * Trap #14 setup to print
        TRAP    #15         * Perform Trap #14
        RTS                 * Return to SIZE67/SIZE68

* --- UNKNOWNOP ----------------------------------------
* PRE  COND     D2 contains the instruction we wish to print.
*               D2 has already been identified as an unknown operation
* 
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
        
        RTS
        *BRA     ITERATION * done with this op, move on to the next iteration

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
JSROP       DC.B    'JSR ',0
RTSOP       DC.B    'RTS',0
LEAOP       DC.B    'LEA',0
BCLROP      DC.B    'BCLR',0
ORIOP       DC.B    'ORI',0
CMPIOP      DC.B    'CMPI',0
DATA        DC.B    ' DATA $',0
OP_BCC_MSG  DC.B    'BCC',0
OP_BCS_MSG  DC.B    'BCS',0
OP_BGE_MSG  DC.B    'BGE',0
OP_BLT_MSG  DC.B    'BLT',0
OP_BVC_MSG  DC.B    'BVC',0
OP_BRA_MSG  DC.B    'BRA',0

 * ----------------------------------------------------------------------------
 * ----------------------------------------------------------------------------
 * Data defined constants
 *   - B/W/L (representing Byte, Word, Long)
 *   - A0-A7 (representing the 8 address registers)
 *   - D0-D7 (representing the 8 data registers)
 * ----------------------------------------------------------------------------

SPACE       DC.B    ' ',0
DOLLAR      DC.B    '$',0
IMD         DC.B    '#',0
COMMA       DC.B    ',',0
OBRACK      DC.B    '(',0
CBRACK      DC.B    ')',0
PLUS        DC.B    '+',0
MINUS       DC.B    '-',0
__B         DC.B    '.B ',0
__W         DC.B    '.W ',0
__L         DC.B    '.L ',0

__A0        DC.B   'A0',0
__A1        DC.B   'A1',0    
__A2        DC.B   'A2',0
__A3        DC.B   'A3',0
__A4        DC.B   'A4',0
__A5        DC.B   'A5',0
__A6        DC.B   'A6',0
__A7        DC.B   'A7',0

__D0        DC.B   'D0',0
__D1        DC.B   'D1',0
__D2        DC.B   'D2',0
__D3        DC.B   'D3',0
__D4        DC.B   'D4',0
__D5        DC.B   'D5',0
__D6        DC.B   'D6',0
__D7        DC.B   'D7',0
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
    NEG.W    -(A7)
    JSR      END

END
    RTS
RLLYEND
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

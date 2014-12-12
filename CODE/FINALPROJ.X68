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
        
        CLR     (__COUNTER)              * setup the counter
        MOVE    #0,(__COUNTER)           
        
        BSR     CLEAR_SCREEN    * clear the prompt for start/end ADDR's
LOOP    
        MOVE.L  A2,A6
        MOVE.L  #8,D3
        BSR     PRINT_ASCII_HEX_CHAR
        
        *MOVE.W  A2,D1           * print what address we are processing
        *MOVE.B  #3,D0
        *TRAP    #15
        
        LEA     SPACE,A1        * print a space to seperate the address from the data
        MOVE.W  #14,D0
        TRAP    #15

        MOVE    D6,-(A7)        * save the bitmask on the stack
        MOVE.W  (A2)+,D2        * Read an operation into D2
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
    
        ADDI    #1,(__COUNTER)           * Track the lines on screen
        CMPI    #30,(__COUNTER)
        BNE     END_OF_LOOP     * Not at 30, go loop more
        BSR     IDLE_STATE      * Break to idle, ask to clear screen

END_OF_LOOP
        CMP     A2,D5           * Compare the starting address to ending address
        BEQ     END             * If they are equal, branch 
        BRA     LOOP            * Otherwise, branch back to LOOP
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------
IDLE_STATE
    LEA     CONT_MSG,A1 * show msg to hit enter in order to continue
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0 * trap task 4 - input
    TRAP    #15
    CMPI    #$D,D1
    
    BSR     CLEAR_SCREEN * clear everything, so ready to output another 30
    CLR.L   (__COUNTER)
    RTS
CLEAR_SCREEN
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS


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
        MOVEM   D0-D7/A0-A1,-(A7)   * Push values to the stack to save
                      
        * Checking for unsupported mode (An) for BCLR, ORI, and CMPI
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6  * Is the mode An, an unsupported mode?
        BEQ     UNKNOWN0000             * If so, the op is unknown
        
        * Checking for BCLR Dynamic
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000110000000, D6  * Are we BCLR Dynamic?
        BNE     NOTBCLRDYNA             * If not, branch to BCLR Static or other ops

        * Confirmed BCLR Dynamic at this point
        LEA     BCLROP,A1           * We found BCLR
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14

        LEA     SPACE,A1            * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out space
        TRAP    #15                 * Perform Trap #14
        
        * Set up for printing out the Register
        BCLR    #6,D2               * Clear bit 6
        BCLR    #7,D2               * Clear bit 7
        BCLR    #8,D2               * Clear bit 8
        
        BSR     EAHELPER611         * Print out Register

        LEA     COMMA,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        CLR     D3                  * clear D3, it is a parameter of ea05 to indicate size
        BSET    #0,D3               * in this case it is always word, so set the first bit of D3
    
        BSR     EAHELPER05          * Print out data.
        
        LEA     NEWLINE,A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     END0000             * Found the op, move to next iteration
        
NOTBCLRDYNA     * Possible options left are BCLR Static, ORI, and CMPI
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #11, D7             * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000100010000000, D6  * Are we BCLR Static?
        BNE     NOTBCLR                 * If not, branch to other functions
        
        * Confirmed BCLR Static at this point
        LEA     BCLROP,A1           * We found BCLR
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14

        LEA     SPACE,A1            * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out space
        TRAP    #15                 * Perform Trap #14
        
        MOVE.L  D2, D4              * Saving values
                
        LEA     IMD, A1             * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        * Grab next word
        MOVE.W (A2)+, D5            * Move the pointer, and store it in D3
        LSL.L   #8, D5              * LSL for first nibble of the word
        LSL.L   #8, D5              * LSL for second nibble of the word
        MOVE.L  D5, A6              * Store D5 into A6, to be used as parameter
        MOVE.L  #4, D3              * Four most significant bits in D3
        BSR     PRINT_ASCII_HEX_CHAR    * Perform number print out

        BRA     SKIPLONG            * Formatting, returning saved values, etc.
        
NOTBCLR * Possible options left are ORI or CMPI
        MOVE.W  #9, D6              * Prep lower value for bitmask
        MOVE.W  #11, D7             * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000000000, D6   * Are we possibly ORI?
        BNE     NOTORI                   * If not, branch to NOTORI
        
        * Size check to see if unsupported ORI mode
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #7, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000011000000, D6  * Are bits 6,7 == 1,1?
        BEQ     UNKNOWN0000             * If so, unknown op. 
        
        * Confirmed ORI at this point
        LEA     ORIOP, A1           * Load 'ORI' into the output window
        MOVE.B  #14,D0              * Trap #14 prints out the data in D0
        TRAP    #15                 * Perform Trap #14

IMD_SIZE_0000        
        BSR     SIZE67              * Print the size

        * Mode check to see the size
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #7, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        MOVE.L  D2, D4              * Saving value
                
        LEA     IMD, A1             * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
               
        * Grab immediate data
        MOVE.W (A2)+, D5            * Move the pointer, and store it in D3
        LSL.L   #8, D5               
        LSL.L   #8, D5
        MOVE.L  D5, A6
        MOVE.L  #4, D3
        BSR     PRINT_ASCII_HEX_CHAR

        CMPI    #%0000000010000000, D6   * See if the size is a LONG
        BNE     SKIPLONG    
        
        * Grab next word
        MOVE.W (A2)+, D5            * Move the pointer, and store it in D3
        LSL.L   #8, D5              * LSL to get first nibble of the word
        LSL.L   #8, D5              * LSL to get second nibble of the word
        MOVE.L  D5, A6              * Store D5 into A6 as a parameter
        MOVE.L  #4, D3              * Move #4 into D3 to show four bits
        BSR     PRINT_ASCII_HEX_CHAR    * Perform number output

SKIPLONG
        LEA     COMMA, A1           * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        MOVE.L  D4, D2              * Return saved value
        
        BSR     EAHELPER05          * Print out the EA
        
        LEA     NEWLINE,A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     END0000             * Done with op. Move to next iteration

NOTORI  * Possible option left is CMPI

        CMPI    #%0000110000000000, D6  * Are we CMPI?
        BNE     UNKNOWN0000             * If not, unknown op
        
        * Confirmed CMPI at this point
        LEA     CMPIOP, A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     IMD_SIZE_0000       * Get immediate value and end opcode 0000
        
UNKNOWN0000
        BSR     UNKNOWNOP          * Unknown op

END0000          
        MOVEM   (A7)+,D0-D7/A0-A1   * Push values to the stack to save
        RTS

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
        
        CMPI    #%0000000001000000,D6
        BNE     OP0001MOVE
        
        LEA     MOVEAOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        BRA     OP0001MOVEA
        
OP0001MOVE

        LEA     MOVEOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
OP0001MOVEA

        LEA     __B,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        MOVE.L  #1,D3
        
        BSR     EAHELPER05
        
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     ENDOP0001
        
UNKNOWNOP0001
        BSR     UNKNOWNOP
        
ENDOP0001
        MOVEM (A7)+,D0-D7/A0-A1
        RTS        
        
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
        MOVEM   D0-D7/A0-A1,-(A7)   * Push vales onto stack
        
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000001000000,D6
        BNE     OP0010MOVE
        
        LEA     MOVEAOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        BRA     OP0010MOVEA
        
OP0010MOVE

        LEA     MOVEOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
OP0010MOVEA

        LEA     __L,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        MOVE.L  #3,D3
        
        BSR     EAHELPER05
        
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     ENDOP0010
        
UNKNOWNOP0010
        BSR     UNKNOWNOP
        
ENDOP0010
        MOVEM (A7)+,D0-D7/A0-A1
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
        MOVEM   D0-D7/A0-A1,-(A7)   * Push vales onto stack
        
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000001000000,D6
        BNE     OP0011MOVE
        
        LEA     MOVEAOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        BRA     OP0011MOVEA
        
OP0011MOVE

        LEA     MOVEOP,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
OP0011MOVEA

        LEA     __W,A1   * Put 'MOVE' into the window
        MOVE.B  #14,D0      * Trap #14 to print out
        TRAP    #15         * Perform Trap #14
        
        MOVE.L  #2,D3
        
        BSR     EAHELPER05
        
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     ENDOP0011
        
UNKNOWNOP0011
        BSR     UNKNOWNOP
        
ENDOP0011
        MOVEM (A7)+,D0-D7/A0-A1
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

        MOVEM   D0-D1/A0-A1,-(A7) * Push values to the stack to save
        
        *NOP
        CMPI    #%0100111001110001,D2
        BNE     NOTNOP
        
        LEA     NOOPERATION,A1
        MOVE.B  #13,D0          * Print a newline
        TRAP    #15
        
        BRA     DONE0100 *we found it, move on to the next iteration
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
        BEQ     UNKNOWN0100 * if it is, print print out as hex indicating bad op
        
        CMPI    #%0000000000101000,D6 * check to see if it is the unsupported mode
        BEQ     UNKNOWN0100 * if it is, print print out as hex indicating bad op
        
        CMPI    #%0000000000110000,D6 * check to see if it is the unsupported mode
        BEQ     UNKNOWN0100 * if it is, print print out as hex indicating bad op
      
        * it is NEG, print
        LEA     NEGOP,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BSR     SIZE67
        
        BSR     EAHELPER05
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     DONE0100 * we found the op, move to next iteration
        
NOTNEG *MOVEM

        * prep values for BITMASK subroutine
        MOVE.L  #7,D6
        MOVE.L  #9,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6   * apply bitmask
        
        CMPI    #%0000000010000000,D6 * is it MOVEM?
        BNE     NOTMOVEM          * it is not MOVEM
        
        MOVE.L  #10,D6
        MOVE.L  #10,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6
        
        CMPI    #%0000000000000000,D6 * is it register to memory?
        BEQ     MOVEMTOMEM 
        
MOVEMTOREG *supported modes: 010 011

        MOVE.L  #3,D6
        MOVE.L  #5,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6
        
        CMPI    #%0000000000000000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000001000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000100000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000101000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000110000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000111000,D6 * is it an unsupported mode?
        BEQ     UNKNOWN0100
        
        LEA     MOVEMOP,A1
        MOVE.B  #14,D0          * print MOVEM
        TRAP    #15
        
        MOVE.L  #6,D6
        MOVE.L  #6,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6
        
        CMPI    #%0000000001000000,D6 * is it a long op?
        BNE     NOTLONGMOVEM1       * no, it is a word
        
        LEA     __L,A1
        MOVE.B  #14,D0          * print .L 
        TRAP    #15
        
        BRA     SKIPNOTLONG1
        
NOTLONGMOVEM1

        LEA     __W,A1
        MOVE.B  #14,D0          * print .W 
        TRAP    #15
                
SKIPNOTLONG1

        BSR     EAHELPER05 * print out the register we are moving from
        
        LEA     COMMA,A1
        MOVE.B  #14,D0          * print , 
        TRAP    #15
        
        BSR     MOVEMHELPERPOST
        
        MOVE.W  (A2)+,D2
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * print a newline 
        TRAP    #15
    
        BRA     DONE0100          * we found and printed, move on to the next iteration
        
MOVEMTOMEM * supported modes 010 100

        MOVE.L  #3,D6
        MOVE.L  #5,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6
        
        CMPI    #%0000000000000000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000001000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000011000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000101000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000000110000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        CMPI    #%0000000001110000,D6 * is it an unsopported mode?
        BEQ     UNKNOWN0100
        
        LEA     MOVEMOP,A1
        MOVE.B  #14,D0          * print MOVEM
        TRAP    #15
        
        MOVE.L  #6,D6
        MOVE.L  #6,D7
        
        BSR     BITMASK
        
        AND.L   D2,D6
        
        CMPI    #%0000000001000000,D6 * is it a long op?
        BNE     NOTLONGMOVEM2       * no, it is a word
        
        LEA     __L,A1
        MOVE.B  #14,D0          * print .L 
        TRAP    #15
        
        BRA     SKIPNOTLONG2
        
NOTLONGMOVEM2

        LEA     __W,A1
        MOVE.B  #14,D0          * print .W 
        TRAP    #15
                
SKIPNOTLONG2

        BSR     MOVEMHELPERPRE

        LEA     COMMA,A1
        MOVE.B  #14,D0          * print , 
        TRAP    #15
        
        BSR     EAHELPER05 * print out the register we are moving to
        
        MOVE.W  (A2)+,D2
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * print a newline 
        TRAP    #15
    
        BRA     DONE0100          * we found and printed, move on to the next iteration

NOTMOVEM *JSR
        * prep values for BITMASK subroutine
        MOVE.L  #6,D6
        MOVE.L  #8,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000010000000,D6
        BNE     NOTJSR          * it's not JSR
        
        LEA     JSROP,A1
        MOVE.B  #14,D0          * Print JSR
        TRAP    #15
        
        LEA     SPACE,A1
        MOVE.B  #14,D0          * Print space
        TRAP    #15
        
        LEA     DOLLAR,A1
        MOVE.B  #14,D0          * Print $
        TRAP    #15
        
        * print out where we are jumping to
        
        MOVE.L  (A2)+,D2 * read in the next word of the instruction

        MOVE.L  D2,D7

        MOVE.L  D7,A6
        
        CLR.L   D3
        
        MOVE.B  #8,D3
        
        BSR     PRINT_ASCII_HEX_CHAR
        
        *MOVE.L  D2,D1   * save the opcode to print
        
        *MOVE.L  #16,D2  * set the base to 16
        
        *MOVE.L  #15,D0  * set D0 to 15 to indicate we are converting to a different base
        *TRAP    #15     * Perform Trap #15, 15 to print out mem add in hex
        
        *MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
        
        *MOVE.L  D2,D1   * save the opcode to print
        
        *MOVE.L  #16,D2  * set the base to 16
        
        *MOVE.L  #15,D0  * set D0 to 15 to indicate we are converting to a different base
        *TRAP    #15     * Perform Trap #15, 15 to print out mem add in hex
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * Print a newline
        TRAP    #15
        
        BRA     DONE0100          * we already found instruction, next iteration
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
        
        BRA     DONE0100          * we already found instruction, next iteration
NOTRTS  *LEA
       
        * prep values for BITMASK subroutine
        MOVE.L  #6,D6
        MOVE.L  #8,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000111000000,D6
        BNE     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        * prep values for BITMASK subroutine
        MOVE.L  #3,D6
        MOVE.L  #5,D7
        
        BSR     BITMASK
        
        AND     D2,D6   * apply bitmask
        
        CMPI    #%0000000000001000,D6
        BEQ     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        CMPI    #%0000000000011000,D6
        BEQ     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        CMPI    #%0000000000100000,D6
        BEQ     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        CMPI    #%0000000000101000,D6
        BEQ     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        CMPI    #%0000000000110000,D6
        BEQ     UNKNOWN0100          * it's not LEA, we dont know what it is
        
        CMPI    #%0000000000111000,D6
        BEQ     TWOWORDLEA          * it's a two word LEA
        
        LEA     LEAOP,A1
        MOVE.B  #14,D0          * Print LEA
        TRAP    #15
        
        BCLR    #7,D2
        BCLR    #8,D2 * needed so eahelper recognizes it as the correct mode
        
        LEA     SPACE,A1
        MOVE.B  #14,D0          * Print SPACE
        TRAP    #15
        
        BSR     EAHELPER05
        
        LEA     COMMA,A1
        MOVE.B  #14,D0          * Print COMMA
        TRAP    #15
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * Start a new line
        TRAP    #15
        
        
        * call EA helper
        * MOVE.W  (A2)+,D2        * simply used to advance the pointer, since it is a two word OP
                
        BRA     DONE0100          * we already found instruction, next iteration
        
TWOWORDLEA

        LEA     LEAOP,A1
        MOVE.B  #14,D0   * Print LEA
        TRAP    #15
        
        LEA     SPACE,A1
        MOVE.B  #14,D0   * Print SPACE
        TRAP    #15

        MOVE.W  (A2)+,D1
        
        MOVE.L  #0,D6
        MOVE.L  #15,D7
        
        BSR     BITMASK
        
        AND.L   D6,D1   * shave off bad info
        
        MOVE.B  #3,D0   * Print the address which was the source
        TRAP    #15
        
        LEA     COMMA,A1
        MOVE.B  #14,D0  * Print COMMA
        TRAP    #15
        
        BCLR    #7,D2
        BCLR    #8,D2 * needed so eahelper recognizes it as the correct mode
        
        BSR     EAHELPER611
        
        LEA     NEWLINE,A1
        MOVE.B  #14,D0          * Start a new line
        TRAP    #15
        
        BRA     DONE0100
        
UNKNOWN0100 *dont know what it is
        BSR     UNKNOWNOP
        
DONE0100
        MOVEM   (A7)+,D0-D1/A0-A1 * Pop off the stack to return our registers
        RTS
        
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
        MOVEM   D0-D7/A0-A1,-(A7)       * Push values to the stack to save

        AND     #%0000000100000000, D6  * Baby-Bitmask for the 8th digit.
        CMPI    #%0000000100000000, D6  * Is the 8th digit a 1?
        BEQ     UNKNOWN0101             * If so, unknown op
      
        CMPI    #%0000000100000000, D6  * Is the size 11, an unsupported value?
        BEQ     UNKNOWN0101             * If so, unknown op
          
        * Verified SUBQ at this point
        LEA     SUBQOP,A1           * Print out SUBQ
        MOVE.B  #14,D0              * Trap #14 to print out
        TRAP    #15                 * Perform Trap #14
                        
        BSR     SIZE67              * Print out size
        
        LEA     IMD,A1              * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out space
        TRAP    #15                 * Perform Trap #14
        
        MOVE.W  #9, D6              * Prep lower value for bitmask
        MOVE.W  #11,D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        BSR     PRINTDATA911        * Special op for immediate in bits 9->11
          
        LEA     COMMA,A1            * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        BSR     EAHELPER05          * Print out the Effective Address
        
        LEA     NEWLINE,A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        MOVEM   (A7)+,D0-D7/A0-A1   * Pop off the stack to return our registers
        RTS
    
UNKNOWN0101
        BSR     UNKNOWNOP
        RTS

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
OP0110  MOVEM.L D0-D7/A0-A6,-(A7) * Save main method routine vars to stack
                        
        MOVE.W  #9,D6  * Move in 9 to D6
        MOVE.W  #11,D7 * Move in 11 to D7
                                      
        BSR     BITMASK * Call BITMASK sub-routine, Returns a bitmask in D6
        AND     D2,D6   * apply the BITMASK
        
        CMPI    #%0000010000000000,D6 * CASE 1: BCC - BINARY FOR "CARRY CLEAR" FLAG
        BEQ     OP_BCC
        CMPI    #%0000010100000000,D6 * CASE 2: BCS - BINARY FOR "CARRY SET" FLAG
        BEQ     OP_BCS
        CMPI    #%0000110000000000,D6 * CASE 3: BGE - BINARY FOR "GREATER OR EQUAL" FLAG
        BEQ     OP_BGE
        CMPI    #%0000110100000000,D6 * CASE 4: BLT - BINARY FOR "LESS THAN" FLAG
        BEQ     OP_BLT
        CMPI    #%0000100000000000,D6 * CASE 5: BVC - BINARY FOR "OVERFLOW CLEAR" FLAG
        BEQ     OP_BVC
        CMPI    #%0000000000000000,D6 * CASE 6: BRA - BINARY FOR "BRANCH ALWAYS" FLAG
        BEQ     OP_BRA
        BSR     UNKNOWNOP             * don't know what it is, print it out, skip to end
        BRA     BCC_END

OP_BCC  LEA     OP_BCC_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BCS  LEA     OP_BCS_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BGE  LEA     OP_BGE_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BLT  LEA     OP_BLT_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BVC  LEA     OP_BVC_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BRA  LEA     OP_BRA_MSG,A1
        BRA     OP_BRANCHES_PRINT
OP_BRANCHES_PRINT
        MOVE.B  #14,D0 * print instruction op, chosen from cases directly above
        TRAP    #15
        
		LEA		DOLLAR,A1
		MOVE.B	#14,D0 * print raw data hex of the LABEL
		TRAP	#15
		
        MOVE.W  #0,D6                 * Move in 0 to D6 - prep mask
        MOVE.W  #7,D7                 * Move in 7 to D7
        BSR     BITMASK               * Call BITMASK sub-routine, return in D6
        AND     D2,D6                 * AND mask with op bits, get last 8 bits in D6
        
*        CMPI    #%00000000,D6         * all 0's == word offset
*        BEQ     BCC_WORD_OFFSET
        
*        CMPI    #%11111111,D6         * all F's == long offset
*        BEQ     BCC_LONG_OFFSET
BCC_BYTE_OFFSET
        CLR     (A4)
        MOVE.L  D6,A4
        LEA     (A4),A1
        MOVE.B  #14,D0
        TRAP    #15
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        BRA     BCC_END
*BCC_WORD_OFFSET
*        MOVEM.W (A2)+,A1
*        MOVE.B  #13,D0
*        TRAP    #15
*        BRA     BCC_END
*BCC_LONG_OFFSET
*        MOVEM.L (A2)+,A1
*        MOVE.B  #13,D0
*        TRAP    #15
*        BRA     BCC_END
BCC_END * reload the memory, call RTS
        MOVEM   (A7)+,D0-D7/A0-A6 * Pop off the stack to return our registers
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
        MOVEM   D0-D7/A0-A1,-(A7)   * Saving values to the stack

        * Check if the EA Mode is 001 since both DIVS and OR do not support it
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6  * Is the mode 001, an unsupported mode?
        BEQ     UNKNOWNOP                 * If so, the op is not supported
        
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
        
        LEA     SPACE,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out space
        TRAP    #15                 * Perform Trap #14
        
        CLR     D3                  * clear D3, it is a parameter of ea05 to indicate size
        BSET    #0,D3               * in this case it is always word, so set the first bit of D3
                                    * to indicate a potential immediate of size word
        
        BSR     EAHELPER05          * Print out data

        LEA     COMMA,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        * bit manipulation is needed to make the outlier DIVS work
        * with the generic EAHELPER611
        BCLR    #6,D2
        BCLR    #7,D2
        BCLR    #8,D2
        
        * the above bits were cleared so that eahelper05 knows the destination
        * is a data register.
        
        BSR     EAHELPER611 

        LEA     NEWLINE,A1          * We found DIVS
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     OP1000END
        
NOTDIVS * It is confirmed OR at this point
        LEA     OROP,A1         * We found OR
        MOVE.B  #14,D0          * Trap #14 prints out the data
        TRAP    #15             * Perform Trap #14
        *================================================================
        * todo, move the size of the operation into the leading bits of D5
        * before subroutine call
        BSR     EAHELPER611

OP1000END
        MOVEM   (A7)+,D0-D7/A0-A1
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
        MOVEM   D0-D7/A0-A1,-(A7)   * Saving values to the stack
        
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        * Check to see if opmode is unsupported for both EOR and CMP
        CMPI    #%0000000011000000, D6      * Is the OPMODE 011, unsupported by SUB?
        BEQ     UNKNOWN1001                 * If so, the OP is unknown
        CMPI    #%0000000111000000, D6      * Is the OPMODE 111, unsupported by SUB?
        BEQ     UNKNOWN1001                 * If so, the OP is unknown
          
        * Check to see if the opmode is EA v Dn -> Dn
        CMPI    #%0000000000000000, D6      * Is the OPMODE 000, a BYTE for EA v DN?
        BEQ     SUB_EA_DN                   * If so, branch to SUB_EA_DN
        CMPI    #%0000000001000000, D6      * Is the OPMODE 001, a WORD for EA v DN?
        BEQ     SUB_EA_DN                   * If so, branch to SUB_EA_DN
        CMPI    #%0000000010000000, D6      * Is the OPMODE 010, a LONG for EA v DN?
        BEQ     SUB_EA_DN                   * If so, branch to SUB_EA_DN
        
        * Need to see if the size is a BYTE and the mode is An direct
        * Since this is not supported
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000100001000, D6      * Is the mode 001 and is a byte?
        BEQ     UNKNOWN1001                 * If so, unsupported op
        
        * Verified to be SUB_DN_EA here
        CMPI    #%0000000000000000, D6      * Is the  000, a BYTE for EA v DN?
        BEQ     SUB_EA_DN                   * If so, branch to SUB_EA_DN

PRINT1001   
        LEA     SUBOP,A1    * We found SUB
        MOVE.B  #14,D0      * Trap #14 prints out a comma
        TRAP    #15         * Perform Trap #14
        
        BSR     SIZE68      * print out the size
        
        BSR     EAHELPER05
        
        * bit manipulation is needed to make EAHELPER611 work
        BCLR    #6,D2
        BCLR    #7,D2
        BCLR    #8,D2
             
        LEA     COMMA,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out comma
        TRAP    #15                 * Perform Trap #1
        
        BSR     EAHELPER611 
        
        LEA     NEWLINE,A1          * formatting
        MOVE.B  #14,D0              * Trap #14 prints out comma
        TRAP    #15                 * Perform Trap #1
        
        BRA     DONE1001
        
SUB_EA_DN
        * SUBA is not supported and must be checked
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6      * Is the mode 001, an unsupported mode for SUB?
        BEQ     UNKNOWN1001                 * If so, branch to UNKNOWN100
        
        BRA     PRINT1001           * Verified to be valid at this point
        
UNKNOWN1001
        BSR     UNKNOWNOP           * Unknown op
        
DONE1001
        MOVEM   (A7)+,D0-D7/A0-A1   * Return vales
        RTS                         * Return to main

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

        MOVEM   D0-D7/A0-A1,-(A7)   * Saving values to the stack

        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        * Check to see if opmode is unsupported for both EOR and CMP
        CMPI    #%0000000011000000, D6      * Is the OPMODE 011, unsupported by EOR/CMP?
        BEQ     UNKNOWN1011                 * If so, the OP is unknown
        CMPI    #%0000000111000000, D6      * Is the OPMODE 111, unsupported by EOR/CMP?
        BEQ     UNKNOWN1011                 * If so, the OP is unknown
        
        * Check to see if it is CMP
        CMPI    #%0000000000000000, D6      * Is the OPMODE 000, a BYTE for CMP?
        BEQ     NOTEOR                      * If so, the OP is CMP
        CMPI    #%0000000001000000, D6      * Is the OPMODE 000, a WORD for CMP?
        BEQ     NOTEOR                      * If so, the OP is CMP
        CMPI    #%0000000010000000, D6      * Is the OPMODE 000, a LONG for CMP?
        BEQ     NOTEOR                      * If so, the OP is CMP

        * Check to see EA mode is 001, unsupported by EOR
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000001000000, D6      * Is the mode 001, unsupported for EOR?
        BEQ     UNKNOWN1011                 * If so, the op is unknown
        
        * Verified to be EOR at this point
        LEA     EOROP,A1            * We found EOR
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     DISPLAY1011         * Branch to the end of 1011       

NOTEOR
        LEA     CMPOP,A1            * We found CMP
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
DISPLAY1011
        BSR     SIZE68
        
        BSR     EAHELPER05
        
        LEA     COMMA,A1            * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BCLR    #6,D2               * Bit manipulation is 
        BCLR    #7,D2               * necessary in order to make
        BCLR    #8,D2               * EAHELPER611 work generically
        
        BSR     EAHELPER611         * Print out EA
        
        LEA     NEWLINE,A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        BRA     DONE1011            * Branch to end 1011 and move to next op
        
UNKNOWN1011
        BSR     UNKNOWNOP           * Unknown op
                 
DONE1011
        MOVEM   (A7)+,D0-D7/A0-A1   * Done identifying op
        RTS                         * Return to main

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
        MOVEM   D0-D7/A0-A1,-(A7)   * Saving values to the stack

        * Check if the EA Mode is 001 since MULS does not support it
        MOVE.W  #3, D6              * Prep lower value for bitmask
        MOVE.W  #5, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000000001000, D6    * Is the mode 001, an unsupported mode?
        BEQ     UNKNOWN1100               * If so, the op is not supported
        
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        
        CMPI    #%0000000111000000, D6  * Are we MULS?
        BNE     UNKNOWN1100             * If not, it is an unknown op
        
        LEA     MULSOP,A1           * We found MULS
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        LEA     SPACE,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out space
        TRAP    #15                 * Perform Trap #14
        
        CLR     D3                  * clear D3, it is a parameter
        BSET    #0,D3               * of EAHELPER05 to indicate size
        
        BSR     EAHELPER05          * Print out data

        LEA     COMMA,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        BCLR    #6,D2               * Bit manipulation is 
        BCLR    #7,D2               * necessary in order to make
        BCLR    #8,D2               * EAHELPER611 work generically
        
        BSR     EAHELPER611         * Print out EA

        LEA     NEWLINE,A1          * Formatting
        MOVE.B  #14,D0              * Trap #14 prints out the data
        TRAP    #15                 * Perform Trap #14
        
        MOVEM   (A7)+,D0-D7/A0-A1   * Done identifying op
        RTS                         * Return to main
        
UNKNOWN1100
        BSR     UNKNOWNOP
     
        MOVEM   (A7)+,D0-D7/A0-A1   * Done identifying op
        RTS                         * Return to main
        
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
        MOVEM.L A0-A6/D0-D7,-(A7)
		
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask
        LSR     #6,D6

		CMPI.B	#%0000000000000000,D6
		BEQ		BYTE_EA_DN

		CMPI.B	#%0000000000000001,D6
		BEQ		WORD_EA_DN

		CMPI.B	#%0000000000000010,D6
		BEQ		LONG_EA_DN

		CMPI.B	#%0000000000000011,D6
		BEQ		ADDA_WORD_OP

		CMPI.B	#%0000000000000100,D6
		BEQ		BYTE_DN_EA

		CMPI.B	#%0000000000000101,D6
		BEQ		WORD_DN_EA

		CMPI.B	#%0000000000000110,D6
		BEQ		LONG_DN_EA

		CMPI.B	#%0000000000000111,D6
		BEQ		ADDA_LONG_OP

		BRA     ADD_ADDA_END
		
BYTE_EA_DN
    	BSR		ADD_EA_DN_GENERIC       * print out 'ADD' base op name for ADDA too

    	LEA		__B,A1                  * print out size
    	MOVE.B	#14,D0
    	TRAP	#15

    	BSR     ADD_ADDA_SPACE          * print out space
    	BRA     ADD_ADDA_PRINT

WORD_EA_DN
    	BSR		ADD_EA_DN_GENERIC

    	LEA		__W,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	
        BSR     ADD_ADDA_SPACE
        BRA     ADD_ADDA_PRINT
    	
LONG_EA_DN
	    BSR		ADD_EA_DN_GENERIC

    	LEA		__L,A1
    	MOVE.B	#14,D0
    	TRAP	#15

    	BSR     ADD_ADDA_SPACE
        BRA     ADD_ADDA_PRINT
    	
ADDA_WORD_OP
	    BSR		ADD_EA_DN_GENERIC

    	LEA		ASCII_A,A1
    	MOVE.B	#14,D0
    	TRAP	#15

    	LEA		__W,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	
        BRA     ADDA_PRT
    	
BYTE_DN_EA
	    BSR     ADD_EA_DN_GENERIC
	    
    	LEA		__B,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	
        BSR     ADD_ADDA_SPACE
        BRA     ADD_ADDA_PRINT

WORD_DN_EA
    	BSR     ADD_EA_DN_GENERIC

    	LEA		__W,A1
    	MOVE.B	#14,D0
    	TRAP	#15	

    	BSR     ADD_ADDA_SPACE
        BRA     ADD_ADDA_PRINT

LONG_DN_EA
    	BSR     ADD_EA_DN_GENERIC
    	
       	LEA		__L,A1
    	MOVE.B	#14,D0
    	TRAP	#15		
    	
        BSR     ADD_ADDA_SPACE
    	BRA     ADD_ADDA_PRINT

ADDA_LONG_OP
    	BSR		ADD_EA_DN_GENERIC
    	
    	LEA		ASCII_A,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	
        LEA		__L,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	
        BRA     ADDA_PRT
        
ADD_EA_DN_GENERIC
		LEA		OP_ADD_MSG,A1           * print out 'ADD'
		MOVE.B	#14,D0
		TRAP	#15
		RTS
		
ADD_ADDA_SPACE
        LEA		SPACE,A1
    	MOVE.B	#14,D0
    	TRAP	#15
    	RTS

ADDA_PRT
        BSR     MODE_DN
        LEA     COMMA,A1
        MOVE.B  #14,D0
        TRAP    #15
        BSR     MODE_AN
        BRA     ADD_ADDA_END

ADD_ADDA_PRINT

        BSR     EAHELPER05          * Print out data. TODO: DOESN'T WORK.

        LEA     COMMA,A1            * formatting
        MOVE.B  #14,D0              * Trap #14 prints out a comma
        TRAP    #15                 * Perform Trap #14
        
        BSR     EAHELPER611
        BRA     ADD_ADDA_END
        
ADD_ADDA_END
        LEA     NEWLINE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVEM.L (A7)+,A0-A6/D0-D7
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

    MOVEM   D0-D7/A0-A1,-(A7)   * Caller saved

    MOVE.L  #3,D6
    MOVE.L  #4,D7
    
    BSR     BITMASK * generate a bitmask for the 3 and 4 bits
    
    AND.L   D2,D6
    
    CMPI    #%0000000000001000,D6 *is it a logical shift
    BEQ     LS
    
    CMPI    #%0000000000000000,D6 *is it an arithmatic shift
    BEQ     AS
    
    CMPI    #%0000000000011000,D6 *is it a rorate?
    BEQ     RO

    BSR     UNKNOWNOP *if nothing above, we don't know what it is
    BRA     ENDOP1110
    
LS
    MOVE.L  #8,D6
    MOVE.L  #8,D7
    
    BSR     BITMASK
    
    AND.L   D2,D6
    
    CMPI    #0,D6 * is it a left shift?
    BEQ     LSR
    
    BRA     LSL * if not a left shift, must be right

LSL

    LEA     LSLOP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out LSL
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data
LSR

    LEA     LSROP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out LSR
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data

AS
    MOVE.L  #8,D6
    MOVE.L  #8,D7
    
    BSR     BITMASK
    
    AND.L   D2,D6
    
    CMPI    #0,D6 * is it a left shift?
    BEQ     ASR
    
    BRA     ASL * if not a left shift, must be right
    
ASL

    LEA     ASLOP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out ASL
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data
ASR

    LEA     ASROP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out ASR
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data
RO
    MOVE.L  #8,D6
    MOVE.L  #8,D7
    
    BSR     BITMASK
    
    AND.L   D2,D6
    
    CMPI    #0,D6 * is it a left shift?
    BEQ     ROR
    
    BRA     ROL * if not a left shift, must be right

ROL

    LEA     ROLOP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out ROL
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data
ROR

    LEA     ROROP,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out ROR
    TRAP    #15                 * Perform Trap #14
    
    BRA     OP1110GENERIC       * a generic part of OP1110 that
                                * prints the registers and imm data

OP1110GENERIC

    BSR     SIZE67
    
    MOVE.L  #5,D6
    MOVE.L  #5,D7
    
    BSR     BITMASK
    
    AND.L   D2,D6
    
    CMPI    #%0000000000100000,D6   *is it a data reg?
    BEQ     OP1110DATAREG
    
    LEA     IMD,A1              * formatting
    MOVE.B  #14,D0              * Trap #14 prints out pound #
    TRAP    #15                 * Perform Trap #14
    
    MOVE.L  #9,D6
    MOVE.L  #11,D7
    
    BSR     BITMASK
    
    AND.L   D2,D6
    
    CMPI    #0,D6 * special case, if zero print #8 not #0
    BEQ     OP1110IMMEIGHT
    
    LSR.L   #8,D6
    LSR.L   #1,D6
    
    MOVE.L  D6,D1              * formatting
    MOVE.B  #3,D0              * Trap #14 prints out the number in D1
    TRAP    #15                * Perform Trap #14
    
    LEA     COMMA,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out comma
    TRAP    #15                 * Perform Trap #1
    
    * in order to use the eahlpers, we need to do some bit manipulation
    * clearing the bits below lets our helper know that the mode is Dn
    BCLR    #3,D2
    BCLR    #4,D2
    BCLR    #5,D2
    
    BSR     EAHELPER05
    
    BRA     ENDOP1110
    
OP1110IMMEIGHT

    MOVE.L  #8,D1              * formatting
    MOVE.B  #3,D0              * Trap #14 prints out the number in D1
    TRAP    #15                * Perform Trap #14
    
    LEA     COMMA,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out comma
    TRAP    #15                 * Perform Trap #1
    
    * in order to use the eahlpers, we need to do some bit manipulation
    * clearing the bits below lets our helper know that the mode is Dn
    BCLR    #3,D2
    BCLR    #4,D2
    BCLR    #5,D2
    
    BSR     EAHELPER05
    
    BRA     ENDOP1110

OP1110DATAREG

    * in order to use the eahlpers, we need to do some bit manipulation
    * clearing the bits below lets our helper know that the mode is Dn
    BCLR    #3,D2
    BCLR    #4,D2
    BCLR    #5,D2
    BCLR    #6,D2
    BCLR    #7,D2
    BCLR    #8,D2
    
    BSR     EAHELPER611
    
    LEA     COMMA,A1            * formatting
    MOVE.B  #14,D0              * Trap #14 prints out comma
    TRAP    #15                 * Perform Trap #14
    
    BSR     EAHELPER05

ENDOP1110

    LEA     NEWLINE,A1          * formatting
    MOVE.B  #14,D0              * Trap #14 prints out a new line
    TRAP    #15                 * Perform Trap #14
    
    MOVEM   (A7)+,D0-D7/A0-A1   * Caller saved
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
*                 D5 contains the size of the data to be printed
* POST-CONDITION: Determines if mode is direct, if it's not, passes D2 to 
*                 EAHELPER05 to print.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
EAHELPER611
    MOVEM  D0-D7/A0-A1,-(A7)    * Push values onto stack
    
    MOVE.W  #6, D6              * Prep lower value for bitmask
    MOVE.W  #8, D7              * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
    AND     D2,D6               * Apply bitmask
    
    * to move the mode where EAHELPER50 can process it
    MOVE.L  #6,D6       * Prep lower value of bitmask
    MOVE.L  #8,D7       * Prep upper value of bitmask
    BSR     BITMASK     * Create bitmask
    AND     D2,D6       * Apply bitmask
    
    CLR     D3      * prep D3 to store values
    MOVE.W  D6,D3   * store bitmasked value in D3
    LSR     #3,D3   * move bits 6-8 to 3-5
    
    * to move the register where EAHELPER50 can process it
    MOVE.L  #9,D6   * Prep lower value for bitmask
    MOVE.L  #11,D7  * Prep upper value for bitmask
    BSR     BITMASK * create bitmask
    AND     D2,D6   * apply bitmask
    
    CLR     D4      * prep D3 to store values
    MOVE.W  D6,D4   * store bitmasked value in D3
    
    LSR     #8,D4   * move bits 9-11 to 0-2
    LSR     #1,D4   * move bits 9-11 to 0-2
  
    OR.L    D4,D3   * combind the register and mode
    MOVE.L  D3,D2   * put the result in D2 so EAHELPER05 can process it
    
    BSR     EAHELPER05
    
ENDEAHELPER611
    
    MOVEM  (A7)+,D0-D7/A0-A1    * Revert back
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
*                 D3 contains the size of immediate it could be, 1 = byte
*                 2 = word, 3 = long
* POST-CONDITION: Determines mode, passes D2 to REGHELPER to print.
* REGISTERS:      a
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
EAHELPER05
    * todo: add code for printing immediate values
    
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

NOTADRINDIRECTPRE

    CMPI    #%0000000000111000,D6 * is it immediate?
    BNE     NOTIMMEDIATE

    CMPI    #1,D3 * is it a byte?
    BNE     NOTIMMBYTE
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.L  #0, D6              * Prep lower value for bitmask
    MOVE.L  #7, D7              * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
        
    MOVE.W  (A2)+,D1
    
    AND.L     D6,D1
        
    MOVE.B  #3,D0   
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05

NOTIMMBYTE
    
    CMPI    #2,D3 * is it a word?
    BNE     NOTIMMWORD
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.L  #0, D6              * Prep lower value for bitmask
    MOVE.L  #15, D7             * Prep upper value for bitmask
    BSR     BITMASK             * Finalize bitmask setup
        
    MOVE.W  (A2)+,D1
    
    AND.L    D6,D1               * Apply bitmask
        
    MOVE.B  #3,D0   
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05
    
NOTIMMWORD
    CMPI    #3,D3 * is it a long?
    BNE     NOTIMMEDIATE
    
    LEA     IMD,A1 *print out the '#' indicating an immediate value
    MOVE.B  #14,D0
    TRAP    #15
        
    MOVE.L  (A2)+,D1
        
    MOVE.B  #3,D0   * Indicate we are using trap #15, 15 to in a certain #base
    TRAP    #15      * Perform Trap #3
    
    BRA     ENDEAHELPER05

NOTIMMEDIATE    


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

        MOVEM   D0-D7/A0-A6, -(A7)  * Save values to return to original when done
        MOVE.W  #6, D6              * Prep lower value for bitmask
        MOVE.W  #8, D7              * Prep upper value for bitmask
        BSR     BITMASK             * Finalize bitmask setup
        AND     D2,D6               * Apply bitmask       

        CMPI    #%0000000000000000, D6  * is it a BYTE?
        BEQ     PRINTBYTE68               * Branch to handle BYTE sizes
        CMPI    #%0000000100000000, D6  * is it a BYTE?
        BEQ     PRINTBYTE68               * Branch to handle BYTE sizes 
      
        CMPI    #%0000000001000000, D6  * is it a WORD?
        BEQ     PRINTWORD68               * Branch to handle BYTE sizes
        CMPI    #%0000000101000000, D6  * is it a WORD?
        BEQ     PRINTWORD68               * Branch to handle BYTE sizes
        CMPI    #%0000000011000000, D6  * is it a WORD (ADDA)?
        BEQ     PRINTWORD68               * Branch to handle BYTE sizes

        CMPI    #%0000000010000000, D6  * is it a LONG?
        BEQ     PRINTLONG68               * Branch to handle BYTE sizes
        CMPI    #%0000000110000000, D6  * is it a LONG?
        BEQ     PRINTLONG68               * Branch to handle BYTE sizes
        CMPI    #%0000000111000000, D6  * is it a LONG (ADDA)?
        BEQ     PRINTLONG68               * Branch to handle BYTE sizes

        BRA     END68
        
PRINTBYTE68
        BSR     PRINTBYTE
        BRA     END68

PRINTWORD68
        BSR     PRINTWORD
        BRA     END68
        
PRINTLONG68
        BSR     PRINTLONG
        BRA     END68

END68
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
* NAME:           MOVEMHELPERPOST
* DESCRIPTION:    Deciphers the myriad of combinations possible for MOVEM
* PRE-CONDITION:  A2 points to the second word of the MOVEM op
* POST-CONDITION: The registers being saved are printed
* REGISTERS:      A2
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
MOVEMHELPERPOST
        MOVEM  D0-D7/A0-A6,-(A7)
        
        CLR.L   D5  * to be used as a loop counter
        CLR.L   D4  * == 1 if we have printed any registers (for fencepost issue)
        CLR.L   D3  * == 1 if we are in a range
        CLR.L   D6  * == 1 if we have already printed the slash or dash
        CLR.L   D7  * == counts the number of registers in a range
        MOVE.B  #1,D6 * to fix fencepost issue
        CLR.L   D2
        MOVE.W  (A2),D2
        
DLOOP * loop to print out the data register portion of the addresses being saved

        ROR     #1,D2
        BCS     DVALID
        
        BRA     DINVALID
        
DVALID
        CMPI    #0,D3
        BEQ     DFORWARDVALID * we are not in a range
        
        ADDI    #1,D7 *increment number of regs in range
        
        CMPI    #1,D6   *have we already printed a symbol?
        BEQ     DLOOPITER
        
        LEA     DASH,A1    *print a dash
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.B  #1,D6 * indicates a symbol has been printed
        
        BRA     DLOOPITER
        
DFORWARDVALID
        * not in a range yet, print
        
        CMPI    #0,D4
        BEQ     DNOSLASH
                
        LEA     SLASH,A1
        MOVE.B  #14,D0
        TRAP    #15
        
DNOSLASH

        MOVE.B  #1,D4 * we have printed something, now slashes are fair game
        
        MOVE.B  #1,D6   * we have printed a symbol
        
        LEA     ASCII_D,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.L  D5,D1
        MOVE.B  #3,D0
        TRAP    #15

        MOVE.B  #1,D3   * set to 1 to indicate we are in a range
        MOVE.B  #0,D6   * set to 0 to indicate we have not printed a symbol
        
        BRA     DLOOPITER


DINVALID

        * were we in a range? if so, print last register, set D3 to zero branch to next iteration also set D6 to 0
        
        CMPI    #1,D3
        BNE     DLOOPITER
        
        MOVE.B  #0,D3
        
        CMPI    #1,D7
        BLT     DLOOPITERCLR
        
        LEA     ASCII_D,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.L  D5,D1
        
        ADDI    #-1,D1 * print out previous reg #, it was the last in the range
        
        MOVE.B  #3,D0
        TRAP    #15
        
        CLR.L   D7
        
        BRA     DLOOPITER
        
DLOOPITERCLR        
        CLR.L   D7

DLOOPITER
        
        CMPI    #8,D5
        BEQ     DLOOPDONE

        ADDI    #1,D5
        BRA     DLOOP

DLOOPDONE

        MOVE.L  #9,D5  * to be used as a loop counter
        CLR.L   D3  * == 1 if we are in a range
        CLR.L   D6  * == 1 if we have already printed the slash or dash
        CLR.L   D7  * count of registers in a range
        MOVE.B  #1,D6 * to fix fencepost issue     

ALOOP * loop to print out the data register portion of the addresses being saved

        ROR     #1,D2
        BCS     AVALID
        
        BRA     AINVALID
        
AVALID
        CMPI    #0,D3
        BEQ     AFORWARDVALID * we are not in a range
        
        ADDI    #1,D7 *increment number of regs in range
        
        CMPI    #1,D6   *have we already printed a symbol?
        BEQ     ALOOPITER
        
        LEA     DASH,A1    *print a dash
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.B  #1,D6 * indicates a symbol has been printed
        
        BRA     ALOOPITER
        
AFORWARDVALID
        * not in a range yet, print
        
                
        CMPI    #0,D4
        BEQ     ANOSLASH
                
        LEA     SLASH,A1
        MOVE.B  #14,D0
        TRAP    #15
        
ANOSLASH

        MOVE.B  #1,D4   * we have printed something, now slashes are fair game
        
        MOVE.B  #1,D6   * we have printed a symbol
        
        LEA     ASCII_A,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.L  D5,D1
        
        ADDI    #-8,D1 * it's A, need to adjust by 8
        
        MOVE.B  #3,D0
        TRAP    #15

        MOVE.B  #1,D3   * set to 1 to indicate we are in a range
        MOVE.B  #0,D6   * set to 0 to indicate we have not printed a symbol
        
        BRA     ALOOPITER


AINVALID

        * were we in a range? if so, print last register, set D3 to zero branch to next iteration also set D6 to 0
        
        CMPI    #1,D3
        BNE     ALOOPITER
        
        MOVE.B  #0,D3
        
        CMPI    #1,D7
        BLT     ALOOPITERCLR
        
        LEA     ASCII_A,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.L  D5,D1
        
        ADDI    #-1,D1 * print out previous reg #, it was the last in the range
        ADDI    #-8,D1 * it's A, need to adjust by 8
        
        MOVE.B  #3,D0
        TRAP    #15
        
        CLR.L   D7
        
        BRA     ALOOPITER
        
ALOOPITERCLR
        
        CLR.L   D7

ALOOPITER
        
        CMPI     #16,D5
        BEQ     ALOOPDONE

        ADDI    #1,D5
        BRA     ALOOP

ALOOPDONE
        
        MOVEM    (A7)+,D0-D7/A0-A6
        RTS

        
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------




*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME:           MOVEMHELPERPRE
* DESCRIPTION:    Deciphers the myriad of combinations possible for MOVEM
* PRE-CONDITION:  A2 points to the second word of the MOVEM op
* POST-CONDITION: The registers being saved are printed
* REGISTERS:      A2
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
MOVEMHELPERPRE

    MOVEM   D1-D7,-(A7)

    MOVE.W  (A2),D2 * move the data we need to proccess into D2
    MOVE.L  #0,D4
    CLR.L    D7 * put the flipped bits here
    
    *the following block of code moves bits
    *into the same position they would be in if
    *the MOVEM was post inc, then simply uses post
    *inc to print the registers being saved
PRELOOP
    ROL.W   #1,D2
    
    BCS     PRESETBIT
    BRA     PRELOOPITER
    
PRESETBIT
    BSET    D4,D7

PRELOOPITER
    CMPI    #15,D4
    BEQ     PRELOOPDONE
    
    ADDI    #1,D4
    BRA     PRELOOP

PRELOOPDONE

    MOVE.W  D7,(A2)    
    MOVEM   (A7)+,D1-D7

    BSR MOVEMHELPERPOST

    RTS



        
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
        MOVEM   D0-D7/A0-A1,-(A7)
        
        LEA     DATA,A1 * load " DATA $" into register A1
        MOVE.L  #14,D0  * print the string stored in A1
        TRAP    #15
        
        LSL.L   #8,D2
        LSL.L   #8,D2
        
        MOVE.L  D2,A6
        
        MOVE.L  #4,D3
        
        BSR     PRINT_ASCII_HEX_CHAR

        LEA     NEWLINE,A1 * load newline into register A1
        MOVE.L  #14,D0  * print the string stored in A1
        TRAP    #15

        MOVEM   (A7)+,D0-D7/A0-A1
        RTS
*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* NAME: Print ASCII hex char
* DESCRIPTION:    Prints and address register to console in hex (ASCII chars)
* PRE-CONDITION:  A6 contains the register of memory to print.
*                 This parameter would be pre-loaded by, for example:
*                 "LEA FOO_BAR_ADDR,A6" or "LEA $1234FEED,A6"
*                 D3 contains the loops to do (number of nibbles).
* POST-CONDITION: 
* REGISTERS:      
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
PRINT_ASCII_HEX_CHAR
    MOVEM.L     D0-D7/A0-A5,-(A7) * push data to save
    CLR.L       D5
    
    * fence post check (if-statement, check if 0 > chars)
    CMPI.B      #0,D3
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
    
        
    CLR.L       D7
    MOVEM.L     (A7)+,D7 * copy back D7 from stack, to mutate its' bits
    
    ADD.B       #1,D5 * loop until counter stops
    CMP.B       D3,D5
    BGE         PRINT_ASCII_FINISH
    
    BRA         PRINT_ASCII_LOOP
INVALID_ASCII_INPUT
PRINT_ASCII_FINISH
    MOVEM.L     (A7)+,D0-D7/A0-A5 * pop saved memory
    RTS
    
PRINTDATA911
    CMPI    #%0000111000000000, D6   * Print 7
    BEQ     PRINT7   
    CMPI    #%0000110000000000, D6   * Print 6
    BEQ     PRINT6
    CMPI    #%0000101000000000, D6   * Print 5
    BEQ     PRINT5
    CMPI    #%0000100000000000, D6   * Print 4
    BEQ     PRINT4 
    CMPI    #%0000011000000000, D6   * Print 3
    BEQ     PRINT3    
    CMPI    #%0000010000000000, D6   * Print 2
    BEQ     PRINT2   
    CMPI    #%0000001000000000, D6   * Print 1
    BEQ     PRINT1     
    CMPI    #%0000000000000000, D6   * Print 0
    BEQ     PRINT8
    
    RTS                             * Fail case  
    
PRINT7
    LEA     ASCII_7, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT6
    LEA     ASCII_6, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT5
    LEA     ASCII_5, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT4
    LEA     ASCII_4, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT3
    LEA     ASCII_3, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT2
    LEA     ASCII_2, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
    
PRINT1
    LEA     ASCII_1, A1
    MOVE.B      #14,D0
    TRAP        #15
    RTS
        
PRINT8
    LEA     ASCII_8, A1
    MOVE.B      #14,D0
    TRAP        #15
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
CONT_MSG    DC.B    'Hit the [ENTER] key to continue...',CR,LF,0
NEWLINE     DC.B    CR,LF,0

* ---> OPS
DIVSOP      DC.B    'DIVS',0
CMPOP       DC.B    'CMP',0
EOROP       DC.B    'EOR',0
NOOPERATION DC.B    'NOP',0
NEGOP       DC.B    'NEG',0
MOVEOP      DC.B    'MOVE',0
MOVEAOP      DC.B   'MOVEA',0
MOVEMOP     DC.B    'MOVEM',0
JSROP       DC.B    'JSR',0
RTSOP       DC.B    'RTS',0
SUBQOP      DC.B    'SUBQ',0
LEAOP       DC.B    'LEA',0
BCLROP      DC.B    'BCLR ',0
MULSOP      DC.B    'MULS',0
OROP        DC.B    'OR',0
ORIOP       DC.B    'ORI',0
CMPIOP      DC.B    'CMPI',0
LSLOP       DC.B    'LSL',0
LSROP       DC.B    'LSR',0
ASLOP       DC.B    'ASL',0
ASROP       DC.B    'ASR',0
ROLOP       DC.B    'ROL',0
ROROP       DC.B    'ROR',0
SUBOP       DC.B    'SUB',0
DATA        DC.B    ' DATA $',0
OP_BCC_MSG  DC.B    'BCC ',0
OP_BCS_MSG  DC.B    'BCS ',0
OP_BGE_MSG  DC.B    'BGE ',0
OP_BLT_MSG  DC.B    'BLT ',0
OP_BVC_MSG  DC.B    'BVC ',0
OP_BRA_MSG  DC.B    'BRA ',0
OP_ADD_MSG  DC.B    'ADD',0

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
SLASH       DC.B    '/',0
DASH        DC.B    '-',0

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

__COUNTER   DS.B    1       * main loop counter

*------------------------[+]END CODE BLOCK SEGMENT[+]-------------------------
*-----------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* SECTION: Sample program to run, then attempt testing disassembly on.
* STARTING: 16384
* ENDING:   Any even number before 16384 to continue FOREVER
*-----------------------[+]START CODE BLOCK SEGMENT[+]------------------------
    ORG $4000
    
    SUB     D0,D1
    SUB     A2,D2   * Should be invalid since this is SUBA
    CMP.B   D0,D1
    CMP.W   D1,D2
    CMP.L   D2,D3
    CMP     A0,D1
    CMP     (A2)+,D1
    EOR.B   D0,D1
    EOR.W   D1,D2
    EOR.L   D2,D3
    EOR     D0,(A0)
    EOR     D1,(A1)+
    ORI.B   #3,D0 
    ORI.W   #$290,D2
    ORI.L   #%1010,D7   * $1010 == A
    ORI     #2,D3
    NOP
    MOVE.B   #%10011010, D0
    MOVE.B   #%10101001, D1
    MOVE.W   #%10011010, D0
    MOVE.W   #%10101001, D1
    MOVE.L   #70000, D0
    MOVE.L   #70000, D1
    DIVS     #1, D0
    ADD.B    D0,D1
    MOVEM    (A7)+,A2-A5/D1/D3-D4
    LEA      JSROP,A1
    NEG.W    -(A7)
    JSR      END
    MULS.W  #3, D7
    MULS    D0, D7
    MULS    (A1)+, D2
    NOP
    AND.L   D2,D3
    SUBQ    #8, D6
    NOP
    SUBQ.L  #7, D1
    NOP
    ORI     #4, D1
    NOP
    LSL.L   #1,D1
    NOP
    LSR.L   #2,D1
    NOP
    ASL.L   #3,D1
    NOP
    ASR.L   #4,D1
    NOP
    ROL.L   #5,D1
    NOP
    ROR.L   #8,D1
    NOP
    BCLR    #2,D1
    NOP
    ADDA.W  D1,A5
    NOP
    ADD.B   D3,D4
    NOP
    BRA     RLLYEND

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

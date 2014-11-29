*---------------------------------------------------------------
* Title      : Convert Memory to Base 16 Output Display Sample
* Written by : Nick Bell
* Date       : Nov. 28th, 2014
* Description: Takes a memory location and outputs as hex
*---------------------------------------------------------------
    ORG    $1000
    
FOO_BAR_ADDR        EQU     $1234FEED

HEX_VALUE_MASK_LONG EQU     $0000000F  * mask a hex value in 32-bits
HEX_BITS_VALUE      EQU     4          * 4 bits per hex value

START:
******************************************
** ex. of how to use/call to print
    LEA             FOO_BAR_ADDR,A6
    MOVE.B          #8,D6
    BSR             PRINT_ASCII_HEX_CHAR
    
    BRA             FIN * stop program
******************************************

* parameters:
* 1)
* a6 = Memory to print
* ex. LEA FOO_BAR_ADDR,A6
* another ex. LEA $1234FEED,A6
* 2) d6 = loops to do (aka how many bytes in a6)
* -----
* d5 == used for loop counter
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

* optional print line
*    LEA         NEWLINE,A1
*    MOVE.B      #14,D0
*    TRAP        #15
    
    SIMHALT             ; halt simulator

* Put variables and constants here
CR          EQU         $0D
LF          EQU         $0A
NEWLINE     DC.B        CR,LF,0
ASCII_0     DC.B        '0',0
ASCII_1     DC.B        '1',0
ASCII_2     DC.B        '2',0
ASCII_3     DC.B        '3',0
ASCII_4     DC.B        '4',0
ASCII_5     DC.B        '5',0
ASCII_6     DC.B        '6',0
ASCII_7     DC.B        '7',0
ASCII_8     DC.B        '8',0
ASCII_9     DC.B        '9',0
ASCII_A     DC.B        'A',0
ASCII_B     DC.B        'B',0
ASCII_C     DC.B        'C',0
ASCII_D     DC.B        'D',0
ASCII_E     DC.B        'E',0
ASCII_F     DC.B        'F',0

FIN
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

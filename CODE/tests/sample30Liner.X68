*----------------------------------------------------------------------------
* Title      : Sample Print Buffer Code
* Written by : Nick Bell
* Date       : Nov. 28th
* Description: Should encapsulate/go around/go outside of the main loop that
*              goes from the starting address to the ending address.  This
*              will print 30 lines of disassembled code, then ask for the
*              user to hit [ENTER] key to continue program output (as per
*              assignment directives request). When the user hits enter, the
*              screen is cleared and up to 30 more lines are printed out.
*              May still need more testing for not having 30 lines to print,
*              for example, at the end/near end of a program, and there's only
*              22 lines and not a full 30 lines.
*----------------------------------------------------------------------------
    ORG    $1000
START:
    * MAIN :: PRINT EX. START
    
LOOP
    LEA     MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    ADDI    #1,D5
    
    CMPI    #30,D5
    BEQ     IDLE_STATE
    
    clr.l   d0
    clr.l   d1
    
    BRA     LOOP
    
IDLE_STATE
    LEA     CONTINUE_MSG,A1 * show msg to hit enter in order to continue
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0 * trap task 4 - input
    TRAP    #15
    cmpi    #$D,D1
    
    BSR     CLEAR_SCREEN * clear everything, so ready to output another 30
    clr.l   d5
    BRA     LOOP * go back to loops
    
    * MAIN :: PRINT EX. END
    
CLEAR_SCREEN
    MOVE.B  #11,D0
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS

END

    SIMHALT

* Put variables and constants here
CR              EQU  $0D
LF              EQU  $0A
CONTINUE_MSG    DC.B 'Hit the [ENTER] key to continue...',CR,LF,0 
MSG             DC.B 'Hello World',CR,LF,0
LINES_ON_SCREEN DS.B 1 * reserve 1 byte to track the lines on screen.

    END    START        ; last line of source
	
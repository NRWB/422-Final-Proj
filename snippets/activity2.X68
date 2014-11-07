*-----------------------------------------------------------
* Title      : Lab 2 Activity 2
* Written by : Nick Bell
* Date       : nov 3rd, 2014
* Description:
*-----------------------------------------------------------
START   ORG    $1000

*-----Code for output-----
LOOP    LEA     MESSAGE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
*-----Code for input-----
        MOVE.B  #4,D0
        TRAP    #15
        CMP.L   #0,D1
        BEQ     DONE
        
        CMP.B   #20,D1
        BLT     INVALID
        CMP.B   #25,D1
        BGT     INVALID
        
*-----figure out what the number actually is--
        CMP.B   #20,D1
        BNE     TWENTY1
        LEA     DISP20,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
TWENTY1 CMP.B   #21,D1
        BNE     TWENTY2
        LEA     DISP21,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
TWENTY2 CMP.B   #22,D1
        BNE     TWENTY3
        LEA     DISP22,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
TWENTY3 CMP.B   #23,D1
        BNE     TWENTY4
        LEA     DISP23,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
TWENTY4 CMP.B   #24,D1
        BNE     TWENTY5
        LEA     DISP24,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
TWENTY5 LEA     DISP25,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
INVALID LEA     INV,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP
        
DONE    MOVE.B  #9,D0
        TRAP    #15
        
CR      EQU     $0D
LF      EQU     $0A

MESSAGE DC.B    'Enter a number between 20 and 25, Enter 0 to exit: ',0
INV     DC.B    'That is not between 20 and 25.',CR,LF,0
DISP20  DC.B    'This town is a lonely town',CR,LF,0
DISP21  DC.B    'Not the only town like-a this town',CR,LF,0
DISP22  DC.B    'This town is a make-you town',CR,LF,0
DISP23  DC.B    'Or a break-you-town and bring-you-down town',CR,LF,0
DISP24  DC.B    'This town is a quiet town',CR,LF,0
DISP25  DC.B    'Or a riot town like this town',CR,LF,0
        
        

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

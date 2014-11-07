*-----------------------------------------------------------
* Title      : Lab 2, Activity 1
* Written by : Nick Bell
* Date       : due nov. 3rd 2014
* Description: 
*-----------------------------------------------------------
    ORG    $1000
START:

    LEA     MESSAGE,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #9,D0
    TRAP    #15
    
CR  EQU     $0D
LF  EQU     $0A
MESSAGE DC.B    'Frank Sinatra',CR,LF
        DC.B    'This Town',CR,LF,CR,LF
        DC.B    'This town is a lonely town',CR,LF
        DC.B    'Not the only town like-a this town',CR,LF
        DC.B    'Or a break-you-town and bring-you-down town',CR,LF
        DC.B    'This is a make-you town',CR,LF,CR,LF
        DC.B    'Thank you for listening!',CR,LF,0
    
        END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

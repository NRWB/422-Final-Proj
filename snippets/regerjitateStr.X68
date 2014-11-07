  ORG   $1000
START: 
  LEA     MESSAGE1,A1 *Loads message into address register A1
    MOVE.B  #14,D0      *Moves number 14 into data regiter D0
    TRAP    #15         *Displays Message
   
    LEA     BUFFER,A1   ; Where to store input string
    MOVE.B  #2,D0       ; Read string
    TRAP    #15

    LEA     MESSAGE2,A1 *Loads message into address register A1
    MOVE.B  #14,D0      *Moves number 14 into data regiter D0
    TRAP    #15         *Displays Message

    LEA     BUFFER,A1   ; String to display
    MOVE.B  #13,D0      ; Display string with newline
    TRAP    #15

    MOVE.B   #9,D0
    TRAP   #15          ; halt simulator
   
message1 dc.b 'enter your string: ',0
message2 dc.b 'string you have entered is: ',0

    ds.w    0       ; force even address
buffer  ds.b    80  ; input string storage

   END   START      ; last line of source 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

.MODEL SMALL

        .STACK 100H

        .DATA

               STR1 DB 0DH,0AH, 'ENTER THE STRING :- $'
               STR2 DB 0DH,0AH, 'YOUR REVERSED STRING IS   :- $'
               nl DB 0DH,0AH,'$' 

        .CODE
         MAIN PROC FAR

                MOV AX,@DATA
                MOV DS,AX


         DISP:
                LEA DX,STR1
                MOV AH,09H
                INT 21H

                MOV CL,00
                MOV AH,01H

         READ:

                INT 21H


                MOV BL,AL

                PUSH BX
                INC CX
                CMP AL,0DH

                JZ DISPLAY
                
                JMP READ
                
         DISPLAY:

                LEA DX,STR2
                MOV AH,09H
                INT 21H

                LEA DX, nl
                MOV AH,09H
                INT 21H
                                
         ANS:
                MOV AH,02H
                POP BX
                MOV DL,BL
                INT 21H
                LOOP ANS
		MOV AH,4CH
		INT 21H


        MAIN ENDP

        END  MAIN
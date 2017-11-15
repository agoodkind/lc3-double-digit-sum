; Alexander Goodkind 
; 11/19/17
; CSC-240
; Professor Dr. Mink
;
; The following program solicits double can add two numbers between the values 00 and 99
;

.ORIG x3000

	; zero out registers that we will be using
	AND R0, R0, #0 	; used for output
	AND R1, R1, #0 	; val1
	AND R2, R2, #0 	; val2
	AND R3, R3, #0 	; 
	AND R4, R4, #0 	; 
	AND R7, R7, #0	;

	LEA R0, programPurpose
	PUTS

	; get our input and store the two for later

	JSR getInput 	; subroutine to get the first two-digit input
	ST R0, valueDecimal1

	JSR getInput 	; subroutine to get the second two-digit input
	ST R0, valueDecimal2

	; load back these values
	LD R1, valueDecimal1
	LD R2, valueDecimal1
	
	; add them together
	ADD R0, R1, R2
	
	; jump to the subroutine that converts the number into ascii
	JSR sumLogic
	
	; print out our final data
	LEA R0, sumPrompt
	PUTS
	LEA R0, sumHundredsPlaceDigit
	PUTS

; end of program
Done	HALT


; sub routine to get input from user
getInput

	AND R0, R0, #0
	ST R1, tempR1
	ST R2, tempR2
	ST R3, tempR3
	ST R4, tempR4
	ST R7, tempR7

	; prompt the user for input

	LEA R0, userPrompt
	PUTS

	; input two place values

	GETC			; input an integer character (this is the 1s place)
	PUTC			; echo
	ST R0, inputValueTens	; store the 10s place

	GETC			; input an integer character (this is the 10s place)
	PUTC			; echo
	ST R0, inputValueOnes	; store the ones place

	; print a new line
	LD R0, newLine
	PUTC

	LD R0, inputValueTens	; load the int into a register
	LD R1, inputValueOnes	; load the int into a register
	LD R2, asciiNegHexOffset; load the ascii offset

	ADD R0, R0, R2		; convert both to decimal
	ADD R1, R1, R2
	ADD R4, R4, R0 		; copy r0 to r4

	
	ADD R3, R3, #9		; counter for multiply
	
	; multiplication logic
	MULTIPLY: 
  		ADD R0, R0, R4 ; add to sum (turning r0 into 10s place)
  		ADD R3, R3, #-1 ; decrement our counter 
	BRp MULTIPLY

	ADD R0, R0, R1 ; add both together to form our number

	; return all of our old values before we RET
	; we don't clear r0 because that's what we are looking through

	LD R1, tempR1
	LD R2, tempR2
	LD R3, tempR3
	LD R4, tempR4
	LD R7, tempR7

RET

sumLogic
	ST R1, tempR1
	ST R2, tempR2
	ST R3, tempR3
	ST R7, tempR7
	; r0 - 100 until not positive = 100s place
	; r0 - 10 until not positve = 10s place
	; r0 remainder = 1s place
	;
	AND R2, R2, #0 ; the counter that we use to find our ascii #

	LD R1, negativeOneHundred 	; #-100 cant be stored directly
	LD R3, asciiHexOffset		; used to find ascii

LoopHundreds
	ADD R2, R2, #1
	ADD R0, R0, R1
	BRp LoopHundreds		; loop until it isnt over 100 anymore

	; account for off-by-1(00) error
	LD R1, oneHundred 
	ADD R0, R0, R1
	ADD R2, R2, #-1			

	ADD R2, R2, R3			; get ascii equivilant
	ST R2, sumHundredsPlaceDigit	; store the hundreds place digit

	; reset counter 
	AND R2, R2, #0 ; the counter

LoopTens
	ADD R2, R2, #1
	ADD R0, R0, #-10
	BRp LoopTens			; loop until it isnt over 100 anymore

	; account for off-by-1(0) error
	ADD R0, R0, #10
	ADD R2, R2, #-1

	ADD R2, R2, R3			; get ascii equivilant
	ST R2, sumTensPlaceDigit	; store the hundreds place digit

LoopOnes
	; get ascii for remaining 1s place
	ADD R0, R0, R3
	ST R0, sumOnesPlaceDigit

	LD R7, tempR7
	LD R3, tempR3
	LD R2, tempR2
	LD R1, tempR1
RET

; our input variables
inputValueOnes 	.fill x0
inputValueTens 	.fill x0

valueDecimal1		.fill x0
valueDecimal2		.fill x0
sumDecimal		.fill x0

sumHundredsPlaceDigit	.fill x0
sumTensPlaceDigit	.fill x0
sumOnesPlaceDigit	.fill x0
sumNullPuts		.fill x0

asciiNegHexOffset 	.fill x-30
asciiHexOffset		.fill x30
oneHundred		.fill #100
negativeOneHundred	.fill #-100

tempR0 .fill x0
tempR1 .fill x0
tempR2 .fill x0
tempR3 .fill x0
tempR4 .fill x0
tempR7 .fill x0

; the user prompt
programPurpose	.STRINGZ "This program will add two 2-digit numbers.\nUse 0 as a placeholder for a single digit number (07 for 7 etc)\n"
userPrompt 	.STRINGZ "Enter a 2-digit number <##>"
sumPrompt	.STRINGZ "Sum is "
newLine		.fill xA

.END
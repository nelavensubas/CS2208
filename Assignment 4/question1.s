			AREA question1, CODE, READONLY
			ENTRY
			LDR r0, =STRING		; make r0 a pointer that points to the string
			LDR r5, =EoS		; make r5 point to the end of string to check if we reached the end
			MOV r1, #-1			; make r1 a pointer that points to the current character in the string
convLow		EQU 32				; add 32 to convert an uppercase letter to lowercase letter in ASCII
LENGTH							; LOOP to find out the length of the string
			LDRB r3, [r0, r2]	; Load a byte of the string, which is a character at position pointed at by r2
			CMP r3, r5			; Check if the character is the null character (EoS)
			BEQ Check			; If it is the null character, then stop length count and exit the loop
			ADD r2, #1			; Else, increment pointer to point to next character
			B LENGTH			; UNTIL end of string is reached and r2 points at EoS
Check							; Pointers of r1 and r2 are located at opposite ends of the string
			CMP r1, r2			; Check if the pointers have crossed paths
			BGT PalCheck		; If the pointer have crossed, then the string is a palindrome as letter pairs have all matched
			ADD r1, #1			; Increment pointer at the start of the string
			SUB r2, #1			; Decrement pointer at the end of the string
Char1							; LOOP
			LDRB r3, [r0, r1]	; Get character 1 at position pointed at by r1
			CMP r3, #'A'		; Check if character 1 is possibly not a letter
			ADDLT r1, #1		; If it is not a letter, increment the pointer
			BLT Char1			; Get the next character
			CMP r3, #'z'		; Check if character is greater than 'z'
			ADDGT r1, #1		; If so, character is not a letter so increment pointer and get next character
			BGT Char1			; UNTIL character is a letter
			CMP r3, #'a'		; Check if character 1 is uppercase
			ADDLT r3, #convLow	; If so, convert character to lowercase by adding 32
Char2							; LOOP
			LDRB r4, [r0, r2]	; Get character 2 at position pointed at by r2
			CMP r4, #'A'		; Check if character 2 is possibly not a letter
			SUBLT r2, #1		; If it is not a letter, decrement the pointer
			BLT Char2			; Get next character
			CMP r4, #'z'		; Check if character 2 is greater than 'z'
			SUBGT r2, #1		; If so, character is not a letter so decrement pointer and get next character
			BGT Char2			; UNTIL character is a letter
			CMP r4, #'a'		; Check if character 2 is uppercase
			ADDLT r4, #convLow	; If so, convert character to lowercase by adding 32
			CMP r3, r4			; Compare character 1 and character 2
			BEQ Check			; If they are equal, the string might be a palindrome. Continue to compare character pairs. If they are not equal, the string is not a palindrome.
			MOV r0, #2			; Set r0 to 2 indicating that the string is not a palindrome
			B Loop				; Skip to end
PalCheck	MOV r0, #1			; Set r0 to 1 indicating thatthe string is a palindrome
Loop		B Loop				; End program with infinite loop
STRING 		DCB "madam, I am Adam."	; string
EoS			DCB 0x00						; end of string
			END
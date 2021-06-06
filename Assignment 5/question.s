		AREA question, CODE, READONLY
		ENTRY
null 	EQU 0x00 							; define a null constant to check for eos
t		EQU 0x74 							; define a 't' constant for comparison
blank 	EQU 0x20 							; define a 'space' constant for comparison
		ADR r1, STRING1 					; pointer to string 1
		ADR r2, STRING2 					; pointer to string 2
		LDR r3, =0x74686520 				; store "the " for comparison
		LDRB r4, [r1] 						; load the first character from string 1
		CMP r4, #t 							; check if the first character is a 't'
		BEQ the 							; if it is branch to check if "he " or "he\0" follows
Loop	LDRB r4, [r1], #1 					; load a character from string 1 and post-increment the pointer
		STRB r4, [r2], #1 					; store the character and post-increment the pointer
		CMP r4, #null 						; check if it's the end of string character
		BEQ inf 							; if it is, then terminate the program
		CMP r4, #blank 						; if not, check for space because "the " or "the\0" may follow
		BNE Loop 							; keep looping until the character is a space
the 	MOV r5, r1 							; save current position of string 1 pointer in case we need to backtrack
		MOV r6, #0 							; reset r6 as this will point at a substring of string 1's next 4 characters
string 	LDRB r4, [r1], #1 					; build the string one character at a time
		CMP r4, #null 						; check if character is at the end of string
		LDREQ r3, =0x74686500 				; if the string is null and is "the\0", it will be removed
		ADD r6, r4 							; append character to the string
		CMP r6, #0x10000000 				; check if string contains less than 4 characters
		LSLLT r6, #8 						; shift the string 1 byte left if it's less than 4 characters
		BLT string 							; continue to build the string until it's fully built
		CMP r6, r3 							; check if string is "the " or "the\0"
		SUBEQ r1, #1 						; if so decrease string 1's pointer to preserve space
		MOVNE r1, r5 						; otherwise, string should not be removed so return to string 1's pointer to initial position
		B Loop 								; repeat character processing until string 1's null character is reached
inf 	B inf 								; terminate the program
STRING1	DCB	"and the man said they must go"	; String1
EoS		DCB	0x00							; end of string1
STRING2	space 0x7f							; just allocating 127 bytes
		ALIGN
		END
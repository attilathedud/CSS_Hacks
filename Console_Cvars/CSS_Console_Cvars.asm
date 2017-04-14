; A POC demonstrating adding a convar to the CSS console and calling CSS console commands. 
; Adding a cvar requires 2 steps: 1. Registering the cvar with the console, and 2. Adding the cvar to  
; the internal linked-list of all cvars.
;
; Originally written 2010/06/02 by attilathedud.

; System descriptors
.386
.model flat,stdcall
option casemap:none

include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

; Since these function reside in a dll that is never loaded dynamically, we don't need to worry
; about offsetting them.
.data
	outputTest db "This is example echo text.",0ah,0
	testDescription db "This is a test description.",0
	conVarTest db "r_test",0
	ori_echo dd 20072340h
	ori_register dd 20227bb0h
	ori_link dd 202a4663h
	ori_link_internal dd 202273b0h
	base dd 0
	
.code
	main:
		; Save the base pointer and load in the stack pointer
		push ebp
	    mov ebp,esp

		; Check to see if the dll is being loaded validly.
	    mov eax,dword ptr ss:[ebp+0ch]
	    cmp eax,1
	    jnz @returnf

		call @init
		
		; Restore all the values and pop back up the call frame.
		pop eax
		@returnf:
			leave
			retn 0ch
			
		; Calls CSS' internal console chat_out function. The function displays the last item pushed on 
		; the stack. It requires the caller to balance the stack.
		@chat_out:
			push eax
			call dword ptr cs:[ori_echo]
			add esp,4
			retn
			
		; CSS' function to link cvars to its linked list contains 2 parts. The first part sets up
		; required items, with the second part accessing the internal list. Before calling the 
		; second part, we have to push the address of this internal helper function on the stack.
		;
		; The internal function requires ecx to hold the base address of the cvar name's location in 
		; memory.
		@link_internal:
			mov ecx,base
			jmp dword ptr cs:[ori_link_internal]
			
		@init:
			; Save the current state of the stack.
			pushad

			; Output our example text message to the console.
			lea eax,outputTest
			call @chat_out
			
			; Allocate a section of memory inside CSS to store the structure created when
			; we register our cvar.
			push 40h
			push 1000h
			push 34h
			push 0
			call VirtualAlloc 
			mov base,eax
			
			; Call CSS' register function. The function declaration:
			; ori_register( char* convar_name, void* struct_out_top, dword unknown, char* convar_description )
			; with ecx containing the base address of struct_out_top.
			lea eax,testDescription
			push eax
			push 80h
			push [base+30h]
			lea eax,conVarTest
			push eax
			mov ecx,base
			call dword ptr cs:[ori_register]
			
			; Link our cvar to the list. The function takes a pointer to the internal link helper function
			; as it's only argument. It requires the caller to fix the stack by +4.
			lea eax,@link_internal
			push eax
			call dword ptr cs:[ori_link]
			pop ecx
			
			; Restore the previous state of the stack.
			popad
			retn
			
	end main
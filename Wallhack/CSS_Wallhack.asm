; A simple wallhack for Counter-Strike: Source. Creates a separate thread in CSS that waits for a keypress
; and then modifies the client variable r_drawothermodels and setting its value to 1. This value is 
; scanned by VAC so this method is not VAC secure.
;
; Originally written 2010/03/20 by attilathedud.

; System descriptors
.386
.model flat,stdcall
option casemap:none

; The address for r_drawothermodels is stored at the base address of client.dll + 3b0c9ch and 
; occupies 8 bytes. For example: client.dll = 24000000h, address = 243b0c9ch.

include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
	toggle db 1
	address dd 0
	dllname db "client.dll"

.code
	main:
		; Save the base pointer and load in the stack pointer
		push ebp
		mov ebp,esp

		; Check to see if the dll is being loaded validly.
		mov eax,dword ptr ss:[ebp+0ch]
		cmp eax,1
		jnz @returnf

		; Save eax on the stack for restoring after we create our thread.
		push eax

		; Get the base address of client.dll. 
		lea eax,dllname
		push eax
		call GetModuleHandle

		; Get the actual address of r_drawothermodels' value.
		add eax,3b0c9ch
		mov address,eax

		; Create the hotkey thread that will listen for keypresses.
		push 0
		push 0
		push 0
		push @hotkey
		push 0
		push 0
		call CreateThread 

		; Restore all the values and pop back up the call frame.
		pop eax
		@returnf:
			leave
			retn 0ch
		
		; The hotkey thread will scan for the F5 key being pressed. When F5 is pressed, our toggle
		; value will be switched to either 0 or 1 and then the address of r_drawothermodels' value
		; will be set to that value.
		;
		; @@ sets up a temporary label. @B jumps back to the last defined temporary label. 
		@hotkey:
			@@:
				push 74h					;F5
				call GetAsyncKeyState 
				and eax,1
				test eax,eax
				jz @B
				cmp toggle,1
				jnz @turn_off
				inc toggle
				jmp @change
				@turn_off:
					dec toggle
					@change:
						mov al,byte ptr ds:[toggle]
						mov ebx,address
						mov dword ptr ds:[ebx],eax
			jmp @B
			retn
	end main
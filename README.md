A couple of old hacks written for post-Orange Box, pre-Global Offensive, Counter-Strike: Source. Both are written in mAsm and compiled into dlls. They can either be built using an IDE like RadASM or by the following script:

```batch
\masm32\bin\ml /c /coff file_name.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL file_name.obj
```

## Console_Cvars
A POC demonstrating adding a convar to the CSS console and calling CSS console commands. Adding a cvar requires 2 steps: 1. Registering the cvar with the console, and 2. Adding the cvar to the internal linked-list of all cvars.

![Screenshot](Console_Cvars/screenshot.jpg?raw=true "Screenshot")

## Wallhack
A simple wallhack for Counter-Strike: Source. Creates a separate thread in CSS that waits for a keypress and then modifies the client variable r_drawothermodels and setting its value to 1. This value is scanned by VAC so this method is not VAC secure.

The address for r_drawothermodels is stored at the base address of client.dll + 3b0c9ch and occupies 8 bytes. For example: client.dll = 24000000h, address = 243b0c9ch.

![Screenshot](/Wallhack/screenshot.jpg?raw=true "Screenshot")

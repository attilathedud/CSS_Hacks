A POC demonstrating adding a convar to the CSS console and calling CSS console commands. Adding a cvar requires 2 steps: 1. Registering the cvar with the console, and 2. Adding the cvar to the internal linked-list of all cvars.

![Screenshot](screenshot.jpg?raw=true "Screenshot")

Originally written 2010/06/02 by attilathedud.

## Some notes

To register a cvar with the console, we need to use the following format:
```
push description
push flags
push initial value
push title
mov ecx,blank section of memory[30h]
call 0e185e00h
push blank section of memory[10h]
call e1f6adfh
```

An example of this in CSS:
```
0E22F5F0   . 68 18F9240E    PUSH engine.0E24F918                     ;  ASCII "Client downloads customization files"
0E22F5F5   . 68 80000000    PUSH 80
0E22F5FA   . 68 30E5230E    PUSH engine.0E23E530
0E22F5FF   . 68 04F9240E    PUSH engine.0E24F904                     ;  ASCII "cl_allowdownload"
0E22F604   . B9 503B330E    MOV ECX,engine.0E333B50
0E22F609   . E8 F267F5FF    CALL engine.0E185E00
0E22F60E   . 68 D08D230E    PUSH engine.0E238DD0	     
0E22F613   . E8 C774FCFF    CALL engine.0E1F6ADF
0E22F618   . 59             POP ECX
0E22F619   . C3             RETN
```

The code CSS uses to add the cvar to the internal linked-list of cvars:
```
0E238DD0     B9 503B330E    MOV ECX,engine.0E333B50
0E238DD5    ^E9 16C8F4FF    JMP engine.0E1855F0
```
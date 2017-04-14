A couple of old hacks written for post-Orange Box, pre-Global Offensive, Counter-Strike: Source. Both are written in mAsm and compiled into dlls. They can either be built using an IDE like RadASM or by the following script:

```batch
\masm32\bin\ml /c /coff file_name.asm
\masm32\bin\Link /SUBSYSTEM:WINDOWS /DLL file_name.obj
```

A simple wallhack for Counter-Strike: Source. Creates a separate thread in CSS that waits for a keypress and then modifies the client variable r_drawothermodels and setting its value to 1. This value is scanned by VAC so this method is not VAC secure.

The address for r_drawothermodels is stored at the base address of client.dll + 3b0c9ch and occupies 8 bytes. For example: client.dll = 24000000h, address = 243b0c9ch.

![Screenshot](screenshot.jpg?raw=true "Screenshot")

Originally written 2010/03/20 by attilathedud.
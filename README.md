# ASIC-Design-of-Low-Power-Configurable-Multi-Clock-Digital-System-With-UART-Transceiver
RTL to GDS|| Implementation of a Digital System supporting Read, Write, Low-Power ALU Operation With/Without Operand Commands through core blocks operation with 50 MHz interfaced with 6.9 KHz UART peripheral.

**Design Flow:**
- 𝙍𝙏𝙇 𝘿𝙚𝙨𝙞𝙜𝙣 𝙤𝙛 50 𝙈𝙃𝙯 𝘾𝙡𝙤𝙘𝙠 𝘿𝙤𝙢𝙖𝙞𝙣 𝘽𝙡𝙤𝙘𝙠𝙨: System Controller , ALU , 16x8 Register File , Clock Gate. 
- 𝙍𝙏𝙇 𝘿𝙚𝙨𝙞𝙜𝙣 𝙤𝙛 9.6 𝙆𝙃𝙯 𝘾𝙡𝙤𝙘𝙠 𝘿𝙤𝙢𝙖𝙞𝙣 𝘽𝙡𝙤𝙘𝙠𝙨: UART Tx , UART Rx , Clock Divider. 
- 𝙍𝙏𝙇 𝘿𝙚𝙨𝙞𝙜𝙣 𝙤𝙛 𝘾𝘿𝘾 𝘽𝙡𝙤𝙘𝙠𝙨: Bit Synchronizer , Data Synchronizer with Pulse Generator , Reset Synchronizer. 
- 𝙎𝙮𝙨𝙩𝙚𝙢 𝙄𝙣𝙩𝙚𝙜𝙧𝙖𝙩𝙞𝙤𝙣 𝙖𝙣𝙙 𝙑𝙚𝙧𝙞𝙛𝙞𝙘𝙖𝙩𝙞𝙤𝙣 Using Emulated Master Self-Checking Testbench. 
- 𝙎𝙮𝙨𝙩𝙚𝙢 𝘾𝙤𝙣𝙨𝙩𝙧𝙖𝙞𝙣𝙞𝙣𝙜 Using Synthesis *TCL Scripts*. 
- 𝙎𝙮𝙨𝙩𝙚𝙢 𝙎𝙮𝙣𝙩𝙝𝙚𝙨𝙞𝙨 𝙖𝙣𝙙 𝙇𝙤𝙜𝙞𝙘𝙖𝙡 𝙊𝙥𝙩𝙞𝙢𝙞𝙯𝙖𝙩𝙞𝙤𝙣 Using *Synopsys Design Compiler* Tool. 
- 𝘼𝙣𝙖𝙡𝙮𝙯𝙚 𝙏𝙞𝙢𝙞𝙣𝙜 𝙋𝙖𝙩𝙝𝙨 and Fix Setup and Hold Violations. 
- 𝙋𝙤𝙨𝙩-𝙎𝙮𝙣𝙩𝙝𝙚𝙨𝙞𝙨 𝙁𝙤𝙧𝙢𝙖𝙡 𝙑𝙚𝙧𝙞𝙛𝙞𝙘𝙖𝙩𝙞𝙤𝙣 Using Synopsys Formality Tool. 
- 𝘿𝙁𝙏 𝙎𝙘𝙖𝙣 𝘾𝙝𝙖𝙞𝙣𝙨 𝙄𝙣𝙨𝙚𝙧𝙩𝙞𝙤𝙣 𝙖𝙣𝙙 𝙋𝙤𝙨𝙩-𝘿𝙁𝙏 𝙁𝙤𝙧𝙢𝙖𝙡 𝙑𝙚𝙧𝙞𝙛𝙞𝙘𝙖𝙩𝙞𝙤𝙣 Using *Synopsys Formality* Tool. 
- 𝘼𝙎𝙄𝘾 𝙋𝙝𝙮𝙨𝙞𝙘𝙖𝙡 𝙄𝙢𝙥𝙡𝙚𝙢𝙚𝙣𝙩𝙖𝙩𝙞𝙤𝙣 𝙖𝙣𝙙 𝙂𝘿𝙎 𝙁𝙞𝙡𝙚 𝙂𝙚𝙣𝙚𝙧𝙖𝙩𝙞𝙤𝙣 Using *Cadence Innovus* Tool. 
- 𝘼𝙎𝙄𝘾 𝙋𝙝𝙮𝙨𝙞𝙘𝙖𝙡 𝙋𝙤𝙨𝙩-𝙇𝙖𝙮𝙤𝙪𝙩 𝙁𝙪𝙣𝙘𝙩𝙞𝙤𝙣𝙖𝙡 𝙑𝙚𝙧𝙞𝙛𝙞𝙘𝙖𝙩𝙞𝙤𝙣 Using Gate Level Simulations.


![system](https://user-images.githubusercontent.com/52181539/223260896-78ce9e0a-9488-4a4b-ac8c-151dcb573205.JPG)

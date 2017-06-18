@ECHO OFF
del "c:\documents and settings\user\desktop\kostis\laba\laba.map"
del "c:\documents and settings\user\desktop\kostis\laba\labels.tmp"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\documents and settings\user\desktop\kostis\laba\labels.tmp" -fI  -o "c:\documents and settings\user\desktop\kostis\laba\laba.hex" -d "c:\documents and settings\user\desktop\kostis\laba\laba.obj" -e "c:\documents and settings\user\desktop\kostis\laba\laba.eep" -m "c:\documents and settings\user\desktop\kostis\laba\laba.map" -W+ie   "C:\Documents and Settings\user\Desktop\kostis\LABA\LABA.asm"

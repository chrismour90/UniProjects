@ECHO OFF
del "c:\documents and settings\user\desktop\kostis\lab2\lab2.map"
del "c:\documents and settings\user\desktop\kostis\lab2\labels.tmp"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\documents and settings\user\desktop\kostis\lab2\labels.tmp" -fI  -o "c:\documents and settings\user\desktop\kostis\lab2\lab2.hex" -d "c:\documents and settings\user\desktop\kostis\lab2\lab2.obj" -e "c:\documents and settings\user\desktop\kostis\lab2\lab2.eep" -m "c:\documents and settings\user\desktop\kostis\lab2\lab2.map" -W+ie   "C:\Documents and Settings\user\Desktop\kostis\lab2\lab2.asm"

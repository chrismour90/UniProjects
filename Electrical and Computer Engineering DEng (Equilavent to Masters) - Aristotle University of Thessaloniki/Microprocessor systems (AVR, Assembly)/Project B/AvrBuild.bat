@ECHO OFF
del "c:\documents and settings\user.csal_pc5\desktop\ergasia2\ergasia2.map"
del "c:\documents and settings\user.csal_pc5\desktop\ergasia2\labels.tmp"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\documents and settings\user.csal_pc5\desktop\ergasia2\labels.tmp" -fI  -o "c:\documents and settings\user.csal_pc5\desktop\ergasia2\ergasia2.hex" -d "c:\documents and settings\user.csal_pc5\desktop\ergasia2\ergasia2.obj" -e "c:\documents and settings\user.csal_pc5\desktop\ergasia2\ergasia2.eep" -m "c:\documents and settings\user.csal_pc5\desktop\ergasia2\ergasia2.map" -W+ie   "C:\Documents and Settings\user.CSAL_PC5\Desktop\Ergasia2\Ergasia2.asm"

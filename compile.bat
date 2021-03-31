@echo off
:drag and drop .love files onto this
copy /b "C:\Program Files\LOVE\love.exe"+%1 "%~n1.exe"
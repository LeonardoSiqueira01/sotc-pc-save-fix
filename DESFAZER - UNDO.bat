@echo off
rem Desfaz a correcao de save / undoes the save fix
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0corrigir_save.ps1" -Desfazer
pause

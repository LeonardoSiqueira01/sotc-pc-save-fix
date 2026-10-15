@echo off
rem Aplica a correcao de save / applies the save fix
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0corrigir_save.ps1"
pause

@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0.."

echo.
for /f %%A in ('git status --short ^| find /c /v ""') do set CHANGES=%%A
echo Changes: %CHANGES%
echo.

if "%CHANGES%"=="0" (
    echo No changes to commit.
    pause
    exit /b 0
)

git status --short
echo.

set /p DO_COMMIT=Do you want to commit? (Y/N):
if /i not "%DO_COMMIT%"=="Y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
set /p SUMMARY=Commit summary:
if "%SUMMARY%"=="" (
    echo Summary cannot be empty.
    pause
    exit /b 1
)

echo.
set /p DESCRIPTION=Commit description (optional, press Enter to skip):

echo.
echo Summary:     %SUMMARY%
if not "%DESCRIPTION%"=="" echo Description: %DESCRIPTION%
echo.

set /p CONFIRM=Is this correct? (Y/N):
if /i not "%CONFIRM%"=="Y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
git add -A
if not "%DESCRIPTION%"=="" (
    git commit -m "%SUMMARY%" -m "%DESCRIPTION%"
) else (
    git commit -m "%SUMMARY%"
)

if errorlevel 1 (
    echo ERROR: Commit failed.
    pause
    exit /b 1
)

echo.
echo Committed %CHANGES% file(s).
echo.
set /p DO_PUSH=Do you want to push? (Y/N):
if /i not "%DO_PUSH%"=="Y" (
    echo Done. Changes committed but not pushed.
    pause
    exit /b 0
)

echo.
git push
if errorlevel 1 (
    echo ERROR: Push failed.
    pause
    exit /b 1
)

echo.
echo Push complete.
pause

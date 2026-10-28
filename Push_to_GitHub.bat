@echo off
cd /d "%~dp0"
title EVS-NMS - Direct GitHub Repository Uploader
echo ============================================================================
echo   EVS-NMS - Automated GitHub Repository Creation ^& Direct Upload
echo ============================================================================
echo.

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed. Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

REM Initialize Git repo if not already initialized
if not exist ".git" (
    git init -b main
    git config user.email "admin@evs-nms.local"
    git config user.name "EVS-NMS Admin"
)

git add .
git commit -m "Initial commit: EVS-NMS Enterprise SNMP & ICMP Monitoring System" 2>nul

REM Check if GitHub CLI (gh) is available for 1-command creation
where gh >nul 2>nul
if %errorlevel% equ 0 (
    echo [INFO] GitHub CLI detected. Creating and pushing repository 'EVS-NMS'...
    gh repo create EVS-NMS --public --source=. --remote=origin --push
    if %errorlevel% equ 0 (
        echo.
        echo [SUCCESS] Repository directly uploaded to GitHub!
        pause
        exit /b 0
    )
)

echo.
echo Enter your GitHub Repository URL (e.g., https://github.com/YourUsername/EVS-NMS.git)
set /p REPO_URL="GitHub Repo URL: "
if "%REPO_URL%"=="" (
    echo [ERROR] No URL provided.
    pause
    exit /b 1
)

git branch -M main
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git push -u origin main

echo.
echo ============================================================================
echo [SUCCESS] EVS-NMS has been pushed to %REPO_URL%
echo GitHub Actions will now automatically compile EVS-NMS.exe in the Actions tab!
echo ============================================================================
pause

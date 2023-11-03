@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
setlocal enabledelayedexpansion
title Browser Installation Menu

:checkagain
cls
title Initializing...
MODE 45,15

echo.
echo ======================================
echo    Browser Installation Script v1.1
echo           Made by craeckor
echo ======================================
echo.

echo Network connection test...
set check=0

REM Repeat the ping check 5 times
for /l %%i in (1,1,5) do (
    timeout 1 /nobreak > nul
    ping 1.1.1.1 -n 1 -w 1000 > nul
    if !errorlevel! equ 0 (
        REM internet working
    ) else (
        set /a check+=1
    )
)

REM Check the value of check variable
if %check% geq 1 (
    echo "There is no internet. Please connect your pc or laptop to the internet via usb to smartphone (usb tethering) or with a network cable (wired connection)."
    echo "After you connected your Laptop or PC to the internet, wait a few seconds and then press any key to retry."
    pause > nul
    goto checkagain
) else (
    REM internet working
)

echo Initialize variables...
set "download_url_duckduckgo="
set "version_tag_duckduckgo="
set header=-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.5" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: none" -H "Sec-Fetch-User: ?1" -H "Pragma: no-cache" -H "Cache-Control: no-cache" -H "TE: trailers"
set "query="
set "min="
set "minpath="
set "min-path-version="

echo Fetch browserdata...
for /f  "tokens=6 delims=/" %%i in ('curl -s !header! "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"') do (
    set "firefoxversion=%%i"
)

for /f "tokens=7 delims=/" %%i in ('curl -s !header! -I "https://github.com/brave/brave-browser/releases/latest" 2^>^&1 ^| findstr "Location:"') do (
    set brave_tag=%%i
)

for /f "tokens=2 delims=^=^"^" %%i in ('curl -s !header! "https://staticcdn.duckduckgo.com/windows-desktop-browser/DuckDuckGo.appinstaller" ^| findstr "Version="') do (
    set version_tag_duckduckgo=%%i
)
set "version_tag_duckduckgo=!version_tag_duckduckgo:"=!"

for /f "tokens=2 delims=^=^"^" %%i in ('curl -s !header! "https://staticcdn.duckduckgo.com/windows-desktop-browser/DuckDuckGo.appinstaller" ^| findstr "!version_tag_duckduckgo!/"') do (
    set download_url_duckduckgo=%%i
)
set "download_url_duckduckgo=!download_url_duckduckgo:"=!"
set "download_url_duckduckgo=!download_url_duckduckgo:/>=!"
set "download_url_duckduckgo=!download_url_duckduckgo: =!"

for /f "tokens=4 delims=/" %%i in ('curl !header! "https://mullvad.net/en/download/browser/win64/latest" -v 2^>^&1 ^| findstr "location:"') do (
    set mullvad_version=%%i
)

for /f "tokens=7 delims=/" %%i in ('curl -s !header! -I "https://github.com/minbrowser/min/releases/latest" 2^>^&1 ^| findstr "Location:"') do (
    set min_tag=%%i
)

echo Check for Min...

for /f "tokens=2 delims=-" %%i in ('dir /b /s "C:\Program Files\Min" ^| findstr "Min-v"') do (
    set min-path-version=%%i
)
if "!min-path-version!" == "" (
    set min-path-version=0
)

if exist "C:\Program Files\Min\Min.exe" (
    set min=yes
    set minpath="C:\Program Files\Min\Min.exe"
) else (
    set min=no
)

if exist "%localappdata%\min\min.exe" (
    set min=yes
    set minpath="%localappdata%\min\min.exe"
) else (
    set min=no
)

if NOT "!min-path-version!" == "0" (
    set min=yes
    set minpath="C:\Program Files\Min\!min-path-version!\Min.exe"
)

:menu
MODE 150,45
title Browser Installation Script v1.1
cls
echo.
echo       _                                                                                                                                   _   
echo     _^| ^|_ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ _^| ^|_ 
echo    ^|_   _^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|_   _^|
echo      ^|_^|      ____                                    _____           _        _ _       _   _               __  __                      ^|_^|  
echo      ^| ^|     ^|  _ \                                  ^|_   _^|         ^| ^|      ^| ^| ^|     ^| ^| (_)             ^|  \/  ^|                     ^| ^|  
echo      ^| ^|     ^| ^|_) ^|_ __ _____      _____  ___ _ __    ^| ^|  _ __  ___^| ^|_ __ _^| ^| ^| __ _^| ^|_ _  ___  _ __   ^| \  / ^| ___ _ __  _   _     ^| ^|  
echo      ^| ^|     ^|  _ ^<^| '__/ _ \ \ /\ / / __^|/ _ \ '__^|   ^| ^| ^| '_ \/ __^| __/ _` ^| ^| ^|/ _` ^| __^| ^|/ _ \^| '_ \  ^| ^|\/^| ^|/ _ \ '_ \^| ^| ^| ^|    ^| ^|  
echo      ^| ^|     ^| ^|_) ^| ^| ^| (_) \ V  V /\__ \  __/ ^|     _^| ^|_^| ^| ^| \__ \ ^|^| (_^| ^| ^| ^| (_^| ^| ^|_^| ^| (_) ^| ^| ^| ^| ^| ^|  ^| ^|  __/ ^| ^| ^| ^|_^| ^|    ^| ^|  
echo      ^| ^|     ^|____/^|_^|  \___/ \_/\_/ ^|___/\___^|_^|    ^|_____^|_^| ^|_^|___/\__\__,_^|_^|_^|\__,_^|\__^|_^|\___/^|_^| ^|_^| ^|_^|  ^|_^|\___^|_^| ^|_^|\__,_^|    ^| ^|  
echo      ^| ^|                                                                                                                                 ^| ^|  
echo      ^|_^|                                                                                                                                 ^|_^|  
echo     _^| ^|_ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ ______ _^| ^|_ 
echo    ^|_   _^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|______^|_   _^|
echo      ^|_^|                                                                                                                                 ^|_^|  
echo.
echo ================================
echo    Which browser do you want?
echo ================================
echo.
echo 1. Firefox Browser (recommended) v!firefoxversion!
echo 2. Brave Browser (recommended, great privacy) !brave_tag!
echo 3. DuckDuckGo Browser (recommended, great privacy) v%version_tag_duckduckgo%
echo 4. Mullvad Browser (recommended, great privacy) v!mullvad_version!
echo 5. Min Browser (recommended, great privacy) !min_tag!
echo 6. Chrome Browser (not recommended, bad privacy - Google) latest Version
echo 7. Opera Browser (not recommended, bad privacy - Chinese Software) latest Version
echo 8. OperaGX Browser (not recommended, bad privacy - Chinese Software) latest Version
if "%min%"=="yes" (
    echo 9. Other - Install your favourite Browser manually - Uses Min for search
) else (
    echo 9. Other - Install your favourite Browser manually - Uses Min for search - Min is currently not installed
    echo --^> If you choose this option the script will download Min temporarly so you can download your favourite Browser with Min.
    echo --^> After you close Min it will delete Min permanently.
)
echo.
set /p choice=Select a browser (1-8): 

if "%choice%"=="1" goto install_firefox
if "%choice%"=="2" goto install_brave
if "%choice%"=="3" goto install_duckduckgo
if "%choice%"=="4" goto install_mullvad
if "%choice%"=="5" goto install_min
if "%choice%"=="6" goto install_chrome
if "%choice%"=="7" goto install_opera
if "%choice%"=="8" goto install_operagx
if "%min%"=="yes" (
    if "%choice%"=="9" goto other
) else (
    if "%choice%"=="9" goto otheri
)

echo Invalid choice. Please select a valid option.
timeout /nobreak 1 >NUL
goto menu

:install_firefox
rem Add installation instructions for Firefox here
echo Installing Firefox v!firefoxversion!...
curl !header! -o "%Temp%\firefox.ini" "https://cdn1.craeckor.ch/data/browsers/firefox.ini" -L -s
curl !header! -o "%Temp%\firefox.exe" "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" -L -s
start /wait /min "" "%Temp%\firefox.exe" /S /INI=%Temp%\firefox.ini
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\firefox.ini" >NUL
del /F /S /Q "%Temp%\firefox.exe" >NUL
set browser=Firefox Browser
goto end

:install_brave
rem Add installation instructions for Brave Browser here
echo Installing Brave Browser %tag%...
curl !header! -o "%Temp%\brave.exe" "https://brave-browser-downloads.s3.brave.com/latest/brave_installer-x64.exe" -L -s
start /wait /min "" "%Temp%\brave.exe" --system-level --silent --install
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\brave.exe" >NUL
set browser=Brave Browser
goto end

:install_duckduckgo
rem Add installation instructions for DuckDuckGo Browser here
echo Installing DuckDuckGo Browser v!version_tag_duckduckgo!...
curl !header! -o "%Temp%\duckduckgo.Appx" "!download_url_duckduckgo!" -s -L
Powershell Add-AppProvisionedPackage -Online -PackagePath "%Temp%\duckduckgo.Appx" -SkipLicense
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\duckduckgo.Appx" >NUL
set "browser=DuckDuckGo Browser"
goto end

:install_mullvad
rem Add installation instructions for Mullvad Browser here
echo Installing Mullvad Browser v!mullvad_version!...
curl !header! -o "%Temp%\mullvad.exe" "https://mullvad.net/en/download/browser/win64/latest" -L -s
"%Temp%\mullvad.exe" /S
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\mullvad.exe" >NUL
set browser=Mullvad Browser
goto end

:install_min
echo Installing Browser !min_tag!
mkdir "%Programfiles%\Min"
curl !header! -o "%Temp%\min-sc.ps1" "https://cdn1.craeckor.ch/data/min/min-sc.ps1" -s -L
curl !header! -o "%USERPROFILE%\Downloads\remove_min.bat" "https://cdn-blog.craeckor.ch/win10ent/rmmin.bat" -s -L
curl !header! -o "%Temp%\min.zip" "https://github.com/minbrowser/min/releases/download/!min_tag!/Min-!min_tag!-windows.zip" -L -s
Powershell Expand-Archive -Path "$ENV:TEMP\min.zip" -DestinationPath "$env:ProgramFiles\Min"
start /wait powershell.exe -ExecutionPolicy Bypass -windowstyle hidden -File "%TEMP%\min-sc.ps1" "!min_tag!"
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\min.zip" >NUL
del /F /S /Q "%Temp%\min-sc.ps1" >NUL
set browser=Min Browser
goto end

:install_chrome
rem Add installation instructions for Chrome here
echo Installing Chrome latest Version...
curl !header! -o "%Temp%\chrome.exe" "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -L -s
start /min /wait "" "%Temp%\chrome.exe" /silent /install
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\chrome.exe" >NUL
set browser=Chrome Browser
goto end

:install_opera
rem Add installation instructions for Opera Browser here
echo Installing Opera Browser latest Version...
:shit1
curl !header! -o "%Temp%\opera.exe" "https://net.geo.opera.com/opera/stable/windows" -L -s
if %errorlevel% equ 6 (
    goto shit1
)
start /min /wait "" "%Temp%\opera.exe" /silent /allusers=1 /launchopera=0 /setdefaultbrowser=1
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\opera.exe" >NUL
set browser=Opera Browser
goto end

:install_operagx
rem Add installation instructions for OperaGX Browser here
echo Installing OperaGX Browser latest Version...
:shit2
curl !header! -o "%Temp%\operagx.exe" "https://net.geo.opera.com/opera_gx/stable/windows" -L -s
if %errorlevel% equ 6 (
    goto shit2
)
start /min /wait "" "%Temp%\operagx.exe" /silent /allusers=1 /launchopera=0 /setdefaultbrowser=1
timeout 10 /nobreak >NUL
del /F /S /Q "%Temp%\operagx.exe" >NUL
set browser=OperaGX Browser
goto end

:other
echo Search your favourite Browser - Starts Min with your search query, if no query entered, it just starts Min with DuckDuckGo as Search-Engine
set /p searchquery=DuckDuckGo Search: 
if "%searchquery%"=="" (
    start "" !minpath! --ignore-certificate-errors "https://duckduckgo.com"
    goto otherend
) else (
    for %%a in (%searchquery%) do (
        set "query=!query!%%a+"
    )
    rem Remove the trailing plus symbol
    set "query=!query:~0,-1!"
    start "" !minpath! --ignore-certificate-errors "https://duckduckgo.com/?q=!query!&t=min"
    goto otherend
)
:otherend
echo Press any key to Exit...
pause >NUL
endlocal
exit

:otheri
echo Download Min...
curl !header! -o "%TEMP%\min.zip" https://github.com/minbrowser/min/releases/download/!min_tag!/Min-!min_tag!-windows.zip -s -L
echo Extract Min...
Powershell Expand-Archive -Path "$ENV:TEMP\min.zip" -DestinationPath "$ENV:TEMP\min"
echo After you close the Min-Window it will delete Min permanently
echo Search your favourite Browser - Starts Min with your search query, if no query entered, it just starts Min with DuckDuckGo as Search-Engine
set /p searchquery=DuckDuckGo Search: 
if "%searchquery%"=="" (
    start /wait "" "%Temp%\min\Min-!min_tag!\Min.exe" --ignore-certificate-errors "https://duckduckgo.com"
    goto otheriend
) else (
    for %%a in (%searchquery%) do (
        set "query=!query!%%a+"
    )
    rem Remove the trailing plus symbol
    set "query=!query:~0,-1!"
    start /wait "" "%Temp%\min\Min-!min_tag!\Min.exe" --ignore-certificate-errors "https://duckduckgo.com/?q=!query!&t=min"
    goto otheriend
)
:otheriend
echo Delete Min...
taskkill /f /im Min.exe >NUL
timeout /nobreak 10 >NUL
rmdir /s /q "%Temp%\min" >NUL
del /f /s /q "%Temp%\min.zip" >NUL
rmdir /s /q "%Appdata%\Min" >NUL

echo Press any key to Exit...
pause >NUL
endlocal
exit

:end
echo Installation complete. Enjoy %browser%!
endlocal
echo Press any key to Exit...
pause >NUL

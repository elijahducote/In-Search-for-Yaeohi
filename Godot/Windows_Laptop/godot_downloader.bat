@echo off
setlocal enabledelayedexpansion

echo ================================================
echo Godot Release Downloader (Mono Version for ARM64)
echo ================================================

:: Set the path to the local curl executable
set "CURL=%~dp0curl\bin\curl.exe"
set "INSTALL_DIR=%~dp0Godot"

:: Check if curl is available
if not exist "%CURL%" (
    echo Error: curl is not found at %CURL%
    pause
    goto :end
)

:: Ensure Godot directory exists
if not exist "%INSTALL_DIR%" (
    echo Creating Godot installation directory...
    mkdir "%INSTALL_DIR%"
    if !errorlevel! neq 0 (
        echo Error: Failed to create Godot directory
        pause
        goto :end
    )
)

echo Fetching latest Godot release information...

:: Get the latest version number from GitHub API (updated repository URL)
powershell -Command "$response = & '%CURL%' -s -H 'Accept: application/vnd.github+json' 'https://api.github.com/repos/godotengine/godot-builds/releases'; $json = $response | ConvertFrom-Json; echo $json[0].tag_name" > version.txt
if not exist version.txt (
    echo Error: Failed to fetch latest version information
    pause
    goto :end
)
set /p LATEST_VERSION=<version.txt
del version.txt

:: Extract version number from existing Godot executable if it exists
set "GODOT_EXE=%INSTALL_DIR%\godot.exe"
set "CURRENT_VERSION="
set "UPDATE_NEEDED=true"

if exist "!GODOT_EXE!" (
    for /f "tokens=1,2 delims= " %%a in ('"%GODOT_EXE%" --version 2^>nul') do (
        set "CURRENT_VERSION=%%b"
    )
    if defined CURRENT_VERSION (
        echo Current Godot version: !CURRENT_VERSION!
        echo Latest Godot version: !LATEST_VERSION!
        
        :: Compare versions
        call :compare_versions "!CURRENT_VERSION!" "!LATEST_VERSION!"
        if !UPDATE_NEEDED!==true (
            echo Update needed. Proceeding with download...
            
            :: Backup existing installation
            if exist "%INSTALL_DIR%" (
                echo Backing up old Godot installation...
                if exist "%INSTALL_DIR%.bak" rd /s /q "%INSTALL_DIR%.bak"
                ren "%INSTALL_DIR%" "Godot.bak"
                mkdir "%INSTALL_DIR%"
            )
        ) else (
            echo Current version is up to date. No update needed.
            call :rename_executables "%INSTALL_DIR%"
            goto :end
        )
    ) else (
        echo Unable to determine current Godot version. Will proceed with update.
    )
) else (
    echo No existing Godot installation found. Proceeding with fresh install...
)

:: Get the JSON response from GitHub API for download URLs (updated repository URL)
powershell -Command "$response = & '%CURL%' -s -H 'Accept: application/vnd.github+json' 'https://api.github.com/repos/godotengine/godot-builds/releases'; $json = $response | ConvertFrom-Json; $urls = $json[0].assets | ForEach-Object { $_.browser_download_url }; $urls | ForEach-Object { echo $_ }" > urls.txt

if not exist urls.txt (
    echo Error: Failed to fetch release information from GitHub
    pause
    goto :end
)

:: Process downloads and extraction
call :process_downloads
goto :end

:compare_versions
:: Compare two version strings and set UPDATE_NEEDED appropriately
:: %~1: Current version (e.g. "4.2.1")
:: %~2: Latest version (e.g. "4.2.1-stable")
setlocal enabledelayedexpansion

:: Strip "-stable" suffix if present
set "current=%~1"
set "latest=%~2"
set "current=!current:-stable=!"
set "latest=!latest:-stable=!"

:: Split versions into major.minor.patch
for /f "tokens=1-3 delims=." %%a in ("!current!") do (
    set "cur_major=%%a"
    set "cur_minor=%%b"
    set "cur_patch=%%c"
)

for /f "tokens=1-3 delims=." %%a in ("!latest!") do (
    set "lat_major=%%a"
    set "lat_minor=%%b"
    set "lat_patch=%%c"
)

:: Compare versions
if !cur_major! LSS !lat_major! (
    endlocal & set "UPDATE_NEEDED=true"
    exit /b
)
if !cur_major! GTR !lat_major! (
    endlocal & set "UPDATE_NEEDED=false"
    exit /b
)

if !cur_minor! LSS !lat_minor! (
    endlocal & set "UPDATE_NEEDED=true"
    exit /b
)
if !cur_minor! GTR !lat_minor! (
    endlocal & set "UPDATE_NEEDED=false"
    exit /b
)

if !cur_patch! LSS !lat_patch! (
    endlocal & set "UPDATE_NEEDED=true"
    exit /b
)

:: If we get here, versions are equal
endlocal & set "UPDATE_NEEDED=false"
exit /b

:process_downloads
:: Modified to ensure we get the Mono ARM64 version first
set "found_first=false"
for /f "delims=" %%A in (urls.txt) do (
    if not "!found_first!"=="true" (
        echo %%A | findstr /i /c:"mono.*windows_arm64" >nul
        if !errorlevel! equ 0 (
            echo %%A | findstr /i /c:".zip" >nul
            if !errorlevel! equ 0 (
                set "found_first=true"
                set "url=%%A"
                :: Extract filename from URL
                for %%F in ("!url!") do set "filename=%%~nxF"
                :: Check if the file already exists and is fully extracted
                if exist "%INSTALL_DIR%\godot.exe" (
                    echo Godot executable already exists, skipping download of !filename!
                    call :rename_executables "%INSTALL_DIR%"
                ) else (
                    call :download_and_extract "%%A" "%INSTALL_DIR%"
                )
            )
        )
    )
)

:: Check if templates directory exists and prompt user
set "download_templates=n"
if exist "%INSTALL_DIR%\editor_data\templates" (
    echo Export templates already exist.
) else (
    echo.
    set /p "download_templates=Would you like to download export templates? (Y/N): "
)

:: Process export templates download if user confirms
if /i "!download_templates!"=="y" (
    :: Modified to ensure we get the Mono export templates
    set "found_second=false"
    for /f "delims=" %%A in (urls.txt) do (
        if not "!found_second!"=="true" (
            echo %%A | findstr /i /c:"mono_export_templates" >nul
            if !errorlevel! equ 0 (
                echo %%A | findstr /i /c:".tpz" >nul
                if !errorlevel! equ 0 (
                    set "found_second=true"
                    set "url=%%A"
                    :: Extract filename from URL
                    for %%F in ("!url!") do set "filename=%%~nxF"
                    call :download_and_extract "%%A" "%INSTALL_DIR%"
                )
            )
        )
    )
) else (
    echo Skipping export templates download.
)

:: Clean up
if exist urls.txt del urls.txt
if exist "%INSTALL_DIR%.bak" rd /s /q "%INSTALL_DIR%.bak"
exit /b

:rename_executables
set "extract_dir=%~1"
echo Checking and renaming executables...

:: First handle console executable to avoid conflicts
if exist "%extract_dir%\Godot_*_console.exe" (
    for %%F in ("%extract_dir%\Godot_*_console.exe") do (
        echo Renaming %%~nxF to godot.console.exe
        move "%%F" "%extract_dir%\godot.console.exe" >nul
    )
)

:: Then handle regular executable
if exist "%extract_dir%\Godot_*.exe" (
    for %%F in ("%extract_dir%\Godot_*.exe") do (
        :: Explicitly exclude console version when renaming regular exe
        echo %%~nxF | findstr /i "_console" >nul
        if !errorlevel! neq 0 (
            echo Renaming %%~nxF to godot.exe
            move "%%F" "%extract_dir%\godot.exe" >nul
        )
    )
)
exit /b

:download_and_extract
set "url=%~1"
set "extract_dir=%~2"
set "temp_dir=%extract_dir%\temp"
for %%F in ("%url%") do set "filename=%%~nxF"

echo Downloading: !filename!
"%CURL%" -L "%url%" -o "%extract_dir%\!filename!" --progress-bar
if !errorlevel! neq 0 (
    echo Error downloading !filename!
    exit /b 1
)

:: Create temporary directory for extraction
if not exist "%temp_dir%" mkdir "%temp_dir%"

:: Extract files
echo Extracting !filename!...
powershell -command "Expand-Archive -Path '%extract_dir%\!filename!' -DestinationPath '%temp_dir%' -Force"
if !errorlevel! neq 0 (
    echo Error extracting !filename!
    exit /b 1
)

:: Move files from temp directory to main directory
echo Moving files to installation directory...
for /f "delims=" %%F in ('dir /b /a-d "%temp_dir%\*"') do (
    move "%temp_dir%\%%F" "%extract_dir%\" >nul
)
for /f "delims=" %%D in ('dir /b /ad "%temp_dir%\*"') do (
    xcopy "%temp_dir%\%%D\*" "%extract_dir%\" /E /Y /Q >nul
)

:: Call rename executables after extraction
call :rename_executables "%extract_dir%"

:: Clean up
echo Cleaning up temporary files...
del "%extract_dir%\!filename!"
rd /s /q "%temp_dir%"

:: Create shortcuts after successful extraction and renaming
if exist "%extract_dir%\godot.exe" (
    call :create_shortcuts
)

exit /b 0

:create_shortcuts
:: Create shortcuts to godot.exe two directories up
set "base_shortcut_path=..\..\Play Game Scene.lnk"
set "project_shortcut_path=..\..\Godot Editor.lnk"

:: Get the absolute path of the project directory (two levels up)
for %%I in ("..\..\") do set "project_absolute_path=%%~fI"
set "project_file=!project_absolute_path!project.godot"
set "godot_exe=%extract_dir%\godot.exe"

:: Create base Godot shortcut if it doesn't exist
if not exist "!base_shortcut_path!" (
    echo Creating shortcut to Godot executable...
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('!base_shortcut_path!'); $Shortcut.TargetPath = '!godot_exe!'; $Shortcut.Save()"
    if !errorlevel! equ 0 (
        echo Base Godot shortcut created successfully.
    ) else (
        echo Failed to create base Godot shortcut.
    )
) else (
    echo Base Godot shortcut already exists.
)

:: Create project-specific shortcut if project file exists and shortcut doesn't
if exist "!project_file!" (
    if not exist "!project_shortcut_path!" (
        echo Creating shortcut to Godot project...
        powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('!project_shortcut_path!'); $Shortcut.TargetPath = '!godot_exe!'; $Shortcut.Arguments = '--editor --path \"!project_absolute_path!\"'; $Shortcut.WorkingDirectory = '!project_absolute_path!'; $Shortcut.Save()"
        if !errorlevel! equ 0 (
            echo Project shortcut created successfully.
        ) else (
            echo Failed to create project shortcut.
        )
    ) else (
        echo Project shortcut already exists.
    )
) else (
    echo No Godot project file found at: !project_file!
    echo Skipping project shortcut creation.
)
exit /b

:end
pause
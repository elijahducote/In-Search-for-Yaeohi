@echo off
setlocal enabledelayedexpansion

set GIT_EXEC="%~dp0Git\bin\sh.exe"
set GIT_AUTH="%USERPROFILE%\.ssh\id_ed25519"
set GIT_AUTH="%USERPROFILE:\=/%/.ssh/id_ed25519"

:: Start ssh-agent and add SSH key without interactive login
%GIT_EXEC% -c "eval $(ssh-agent -s) && ssh-add %GIT_AUTH%"
%GIT_EXEC% -c "git config --global init.defaultBranch main"
%GIT_EXEC% -c "git config --global user.email 'validpupflower@gmail.com'"
%GIT_EXEC% -c "git config --global user.name 'ElijahDucote'"
:: Set the remote origin
set REPO_URL="https://github.com/elijahducote/In-Search-for-Yaeohi.git"

:: Ensure we're in the local repo
if not exist .git (
    %GIT_EXEC% -c "git init && git remote add origin https://github.com/elijahducote/In-Search-for-Yaeohi.git"
    %GIT_EXEC% -c "git remote set-url origin https://github.com/elijahducote/In-Search-for-Yaeohi.git"
)

:: Fetch the remote repo
%GIT_EXEC% -c "git fetch origin"

:: Stage files and check for changes
%GIT_EXEC% -c "git add . && git diff --cached --exit-code" > nul 2>&1
if %errorlevel% neq 0 (
    :: Prompt for commit message
    set /p COMMIT_MSG="Enter commit message: "
    
    :: Commit changes
    %GIT_EXEC% -c "git commit -m 'Source'"
    
    :: Push to remote origin
    %GIT_EXEC% -c "git push -f origin main"
) else (
    echo No changes to commit.
)

pause
endlocal
@echo off

REM this script assumes that both SRC_DIST_DIR and SRC_CONF_DIR do contain files

set BASE_DIR=%CD%
set SCRIPT_DIR=%~dp0

set WORKING_DIR=%BASE_DIR%\temp

set SRC_DIST_DIR=%BASE_DIR%\dist
set OUT_DIST_DIR=%BASE_DIR%\temp\dist

set SRC_CONF_DIR=%BASE_DIR%\conf
set OUT_CONF_DIR=%BASE_DIR%\temp\conf

echo cleaning temporary directory: %WORKING_DIR%
rmdir /S /Q %WORKING_DIR%
mkdir %OUT_DIST_DIR%
mkdir %OUT_CONF_DIR%

echo zipping distribution files contained in: %SRC_DIST_DIR%
%SCRIPT_DIR%\7za.exe a -tzip %OUT_DIST_DIR%\dist_%BUILD_NUMBER% %SRC_DIST_DIR%

echo zipping configuration files contained in: %SRC_CONF_DIR%
%SCRIPT_DIR%\7za.exe a -tzip %OUT_CONF_DIR%\conf_%BUILD_NUMBER% %SRC_CONF_DIR%

echo creating final artifact archive
%SCRIPT_DIR%\7za.exe a -tzip "%WORKING_DIR%\%JOB_NAME%_REL_%AVS_RELEASE_NUMBER%.zip" %OUT_CONF_DIR%
%SCRIPT_DIR%\7za.exe a -tzip "%WORKING_DIR%\%JOB_NAME%_REL_%AVS_RELEASE_NUMBER%.zip" %OUT_DIST_DIR%


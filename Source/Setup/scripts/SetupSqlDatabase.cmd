@echo off

setlocal 
%~d0
cd "%~dp0"

@REM  -------------------------------------------------------------
@REM  You can change server and database name here.
@REM  -------------------------------------------------------------

:select
SET /p sqlServer=Please enter the Windows Azure SQL Database Server Address (e.g: yourserver.database.windows.net):
SET /p User=Please enter the User to connect to Windows Azure SQL Database (e.g: yourusername@yourserver):
SET /p Password=Please enter the Password to Connect to Windows Azure SQL Database:
SET dbName=Northwind2

echo.
echo ===========================
echo Northwind database setup 
echo ===========================
echo.
echo SQL Server: %sqlServer%
echo User: %User%
echo Password: %Password%
echo.

CHOICE /C YN /D Y /T 10 /M "Are these values correct"
IF ERRORLEVEL 2 GOTO select

echo IN PROGRESS: Dropping database '%dbName%' on '%sqlServer%' if it exists...
SQLCMD -S %sqlServer% -U %User% -P %Password% -d master -Q "DROP DATABASE [%dbName%]"
IF ERRORLEVEL 1 GOTO ERROR

echo IN PROGRESS: Creating database '%dbName%' on '%sqlServer%'...
SQLCMD -S %sqlServer% -U %User% -P %Password% -b -d master -Q "CREATE DATABASE [%dbName%]"
IF ERRORLEVEL 1 GOTO ERROR

echo IN PROGRESS: Creating tables in '%dbName%' database on '%sqlServer%'...
SQLCMD -S %sqlServer% -d "%dbName%" -U %User% -P %Password% -b -i "NorthwindProducts.sql"
IF ERRORLEVEL 1 GOTO ERROR



echo =============================================================================
echo SUCCESS: '%dbName%' database created on '%sqlServer%'
echo REMEMBER change the connection string for each begin end solutions with your Windows Azure SQL Database account
echo =========================================================================isq====
GOTO EXIT

:ERROR
echo.
echo ======================================
echo An error occured. 
echo Please review errors above.
echo ======================================
GOTO EXIT

:EXIT
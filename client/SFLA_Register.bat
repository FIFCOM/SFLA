@echo off
title Register a new account
mode con: cols=65 lines=25
color 8b

:menu
cls
echo.
echo.      Register a new account
echo.   ___________________________________________________________
echo.
echo.
set uid=null
set /p uid=       Username:
if \"%uid%\"==\"null\" goto menu
echo.
set password=null
set /p password=       Password:
If \"%password%\"==\"null\" goto menu
echo.
set password_verify=null
set /p password_verify=       Confirm password:
if \"%password_verify%\"==\"null\" goto menu
if %password%==%password_verify% goto verify_uid
goto password_verify_failure
:password_verify_failure
cls
echo.
echo.      Register a new account
echo.   ___________________________________________________________
echo.
echo.      The passwords entered twice are not the same! 
echo.
echo.      Please try again.
echo.
set /p password=       Password:
echo.
set /p password_verify=       Confirm password:
if %password%==%password_verify% goto verify_uid
goto password_verify_failure
:verify_uid
echo.      
echo.       Please wait...
md5.exe -d%uid%>$
set /p md5_uid=<$
del $
if exist %temp%\%md5_uid%.key del %temp%\%md5_uid%.key>nul
wget.exe -P "%temp%" "http://your.server.domain/dir/%md5_uid%.key"
:verify_uid_1
::Determine if the download is complete
if exist %temp%\%md5_uid%.key (verify_uid_2) else goto set_accounts_info
:verify_uid_2
if exist %temp%\%md5_uid%.key del %temp%\%md5_uid%.key>nul
cls
::The account exists
goto verify_uid_exist
:verify_uid_exist
cls
echo.
echo.      Register a new account
echo.   ___________________________________________________________
echo.
echo.
echo.      Current account has been registered,Please try again.
echo.
echo.      Current account:%uid%
echo.
echo.      Press any key to continue...
pause>nul
goto menu

:set_accounts_info
cls
echo.
echo.      Improve account information
echo.   ___________________________________________________________
echo.
echo.
set /p qq=       Tencent QQ:
echo.
set /p email=       E-mail:
echo.
echo.      The program will collect the device information.
echo.
echo.      Press any key to continue...
pause>nul
goto reg

:reg
cls
echo.
echo.      Please wait a moment...
if exist %temp%\reg.data del %temp%\reg.data
echo.uid=%uid%>%temp%\reg.data
echo.password=%password%>>%temp%\reg.data
echo.qq=%qq%>>%temp%\reg.data
echo.email=%email%>>%temp%\reg.data
for /f "tokens=2* delims=[]" %%i in ('ver') do set v=%%i
for /f "tokens=2* delims= " %%i in ("%v%") do set windowsversion=%%i
echo.os=%windowsversion%>>%temp%\reg.data
echo.computername=%COMPUTERNAME%>>%temp%\reg.data
wmic cpu get ProcessorId /format:textvaluelist.xsl >$
for /f "delims== tokens=1*" %%a in ('type $ ^|C:\Windows\System32\findstr /i "ProcessorId"') do set machinekey=%%b
del $
echo.machinekey=%machinekey%>>%temp%\reg.data
set "URL=http://www.ip138.com/ips1388.asp"  
for /f "tokens=2 delims=[]" %%a in ('wget -q "%URL%" -O -') do (  
    set "PublicIP=%%a"  
)  
echo.ipaddr=%PublicIP%>>%temp%\reg.data
echo.username=%username%>>%temp%\reg.data
setlocal ENABLEDELAYEDEXPANSION
for /f "tokens=1,* delims==" %%a in ('wmic cpu get name^,ExtClock^,CpuStatus^,Description /value') do (
set /a tee+=1
if "!tee!" == "6" echo cpu=%%b>>%temp%\reg.data
)
goto encrypt

:encrypt
move "%temp%\reg.data" %temp%\reg.data.FEC >nul
FEC.exe -e Your_Public_Random_Key %temp%\reg.data.FEC %temp%\reg.data
if exist %temp%\reg.data.FEC del %temp%\reg.data.FEC
if exist %temp%\reg.txt del %temp%\reg.txt
C:\Windows\System32\certutil -encode %temp%\reg.data %temp%\reg.txt
if exist %temp%\reg.data del %temp%\reg.data
echo. >>%temp%\reg.txt
echo.information 1. >>%temp%\reg.txt
echo.information 2. >>%temp%\reg.txt
start %temp%\reg.txt
cls
echo.
echo.      Register a new account
echo.   ___________________________________________________________
echo.
echo.
echo.      The registration file has been generated!
echo.
echo.      Please refer to the file description to complete
echo.
echo.      the registration.
echo.
echo.      Press any key to exit...
pause>nul
exit

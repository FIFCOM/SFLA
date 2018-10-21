@echo off
cls
color 8b
title SFLA Server

:login
if not exist sfla.lock goto inst
cls
echo.
echo.      SFLA Server - Login
echo.   ___________________________________________________________
echo.
echo.
echo.      Verify your identity to continue.
echo.
set password=null
set /p password=       Enter Password:
if %password%==\"null\" goto login
FEC.exe -d %password% "sfla.lock" "sfla.lock.tmp"
if not exist "sfla.lock.tmp" (goto login) else del sfla.lock.tmp && goto menu
goto login

:inst
if exist sfla.lock goto login
cls
echo.
echo.      SFLA Server - Install
echo.   ___________________________________________________________
echo.
echo.
echo.      Can only be used after setting a password.
echo.
set password=null
set /p password=       Enter Password:
if %password%==\"null\" goto inst
echo.
set /p password_verify=       Confirm password:
if not %password%==%password_verify% goto inst
echo.SFLA SERVER - %COMPUTERNAME% %username% >sfla.lock.tmp
FEC.exe -e %password% "sfla.lock.tmp" "sfla.lock"
del sfla.lock.tmp
md users
md accounts
goto login

:menu
cls
echo.
echo.      SFLA Server
echo.   ___________________________________________________________
echo.
echo.
echo.      1. Users Viewer
echo.
echo.      2. SFLA Register
echo.
echo.      0. Exit
echo.
Set /p menu_select=       Input serial number:

If "%menu_select%"=="1" goto viewer
If "%menu_select%"=="2" goto register
If "%menu_select%"=="0" goto exit
goto menu

:register
echo. >reg.txt
start reg.txt
cls
echo.
echo.      SFLA Server
echo.   ___________________________________________________________
echo.
echo.
echo.      Please paste the SFLA Registration Certificate...
echo.
echo.      Press any key to continue...
pause>nul
cls
echo.Please wait...
C:\Windows\System32\certutil -decode reg.txt reg.txt.FEC
del reg.txt
FEC.exe -d Your_Public_Random_Key reg.txt.FEC reg.txt
del reg.txt.FEC
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "uid"') do set r_uid=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "qq"') do set r_qq=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "username"') do set r_usrname=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "ipaddr"') do set r_ipaddr=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "password"') do set r_password=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "computername"') do set r_computername=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "machinekey"') do set r_machinekey=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "email"') do set r_email=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "cpu"') do set r_cpu=%%b
for /f "delims== tokens=1*" %%a in ('type reg.txt ^|C:\Windows\System32\findstr /i "os"') do set r_os=%%b
echo.uid=%r_uid% >>users\%r_uid%.sfla.tmp
echo.password=r_password% >>users\%r_uid%.sfla.tmp
echo.qq=r_qq% >>users\%r_uid%.sfla.tmp
echo.email=%r_email% >>users\%r_uid%.sfla.tmp
echo.ip=%r_ipaddr% >>users\%r_uid%.sfla.tmp
echo.username=%r_usrname% >>users\%r_uid%.sfla.tmp
echo.machinekey=%r_machinekey% >>users\%r_uid%.sfla.tmp
echo.cpu=%r_cpu% >>users\%r_uid%.sfla.tmp
echo.os=%r_os% >>users\%r_uid%.sfla.tmp
del reg.txt
md5 -d%r_uid%>$
set /p md5_uid=<$
md5 -d%r_password%>$
set /p md5_password=<$
del $
echo.uid=%r_uid%>%md5_uid%.key.FEC
echo.email=%r_email%>>%md5_uid%.key.FEC
echo.machinekey=%r_machinekey%>>%md5_uid%.key.FEC
echo.ip=%r_ipaddr%>>%md5_uid%.key.FEC
FEC.exe -e %md5_password% %md5_uid%.key.FEC accounts\%md5_uid%.key
FEC.exe -e %password% users\%r_uid%.sfla.tmp users\%r_uid%.sfla
del %md5_uid%.key.FEC
del %r_uid%.sfla
cls
echo.
echo. User Info:
echo.
echo. Username:%r_uid% MD5:%md5_uid%
echo.
echo. Password:%r_password% MD5:%md5_password%
echo.
echo. IP address:%r_ipaddr%
echo.
echo. Contact information:
echo.
echo. QQ:%r_qq%
echo.
echo. Email:%r_email%
echo.
echo. Computer information:
echo.
echo. System version:%r_os%
echo.
echo. CPU:%r_cpu%
echo.
echo. Machine code:%r_machinekey%
echo.
echo. PC Username:%r_usrname%
echo.
echo. Computer name:%r_computername%
echo.
echo. Press any key to exit...
pause>nul
goto menu

:viewer
cls
echo.
echo.      SFLA Server
echo.   ___________________________________________________________
echo.
echo.
echo.      SFLA Viewer can query registered user information.
echo.
set viewer_users=null
Set /p viewer_users=       Enter Username:
if %viewer_users%==\"null\" goto viewer
if not exist "users\%viewer_users%.sfla" goto viewer
FEC.exe -d %password% "users\%viewer_users%.sfla" "users\%viewer_users%.sfla.tmp"
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "uid"') do set r_uid=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "qq"') do set r_qq=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "username"') do set r_usrname=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "ipaddr"') do set r_ipaddr=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "password"') do set r_password=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "computername"') do set r_computername=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "machinekey"') do set r_machinekey=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "email"') do set r_email=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "cpu"') do set r_cpu=%%b
for /f "delims== tokens=1*" %%a in ('type users\%viewer_users%.sfla.tmp ^|C:\Windows\System32\findstr /i "os"') do set r_os=%%b
del users\%viewer_users%.sfla.tmp
md5 -d%r_uid%>$
set /p md5_uid=<$
md5 -d%r_password%>$
set /p md5_password=<$
del $
cls
echo.
echo. User Info:
echo.
echo. Username:%r_uid% MD5:%md5_uid%
echo.
echo. Password:%r_password% MD5:%md5_password%
echo.
echo. IP address:%r_ipaddr%
echo.
echo. Contact information:
echo.
echo. QQ:%r_qq%
echo.
echo. Email:%r_email%
echo.
echo. Computer information:
echo.
echo. System version:%r_os%
echo.
echo. CPU:%r_cpu%
echo.
echo. Machine code:%r_machinekey%
echo.
echo. PC Username:%r_usrname%
echo.
echo. Computer name:%r_computername%
echo.
echo. Press any key to exit...
pause>nul
goto menu

:exit
exit
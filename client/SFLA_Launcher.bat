@echo off
title SFLA Login Launcher
mode con: cols=65 lines=25
color 8b

:login
cls
if exist %temp%\login_uid.sfla (set /p md5_uid=<%temp%\login_uid.sfla && goto login_verify) else goto login_uid

:login_uid
cls
echo.
echo.      SFLA Login Launcher
echo.   ___________________________________________________________
echo.
echo.
echo.      Enter your username and password to login.
echo.
set uid=null
Set /p uid=       ÓÃ»§Ãû:
If \"%uid%\"==\"null\" goto login_uid
md5.exe -d%uid%>$
set /p md5_uid=<$
del $
goto login_verify

:login_verify
echo.
echo.       Please wait...
if exist %temp%\login_pass.sfla (set /p md5_password=<%temp%\login_pass.sfla && goto login_decrypt) else echo.
if exist %temp%\login_uid.dat (del %temp%\login_uid.dat) else echo.
if exist "%temp%\%md5_uid%.key" (del "%temp%\%md5_uid%.key") else echo.
echo.%md5_uid%>>%temp%\login_uid.dat
echo.%uid%>>%temp%\uid.sfla
wget.exe -P "%temp%" "http://your.server.domain/dir/%md5_uid%.key"
title SFLA Login Launcher
:login_verify_1
::Determine if the download is complete
if exist "%temp%\%md5_uid%.key" (goto login_password) else goto login_uid_not_found

:login_uid_not_found
cls
echo.
echo.      SFLA Login Launcher
echo.   ___________________________________________________________
echo.
echo.
echo.      The current account does not exist.
echo.
echo.      Press any key to login again...
pause>nul
goto login_uid

:login_password
cls
echo.
echo.      SFLA Login Launcher
echo.   ___________________________________________________________
echo.
echo.
echo.      Your password will not be leaked.
echo.
set password=null
Set /p password=       Password:
If \"%password%\"==\"null\" goto login_password
goto login_decrypt
:login_decrypt
cls
move "%temp%\%md5_uid%.key" "%temp%\%md5_uid%.key.FEC"
md5.exe -d%password% >%temp%\md5.txt
set /p md5_password=<%temp%\md5.txt
del %temp%\md5.txt
FEC.exe -d %md5_password% "%temp%\%md5_uid%.key.FEC" "%temp%\%md5_uid%.key"
if exist "%temp%\%md5_uid%.key" (del "%temp%\%md5_uid%.key.FEC") else goto login_decrypt_failure
goto login_decrypt_success
:login_decrypt_success
cls
goto verify_device
:login_decrypt_failure
cls
echo.
echo.      SFLA Login Launcher
echo.   ___________________________________________________________
echo.
echo.
echo.      Wrong password! Please try again
echo.
set password=null
Set /p password=       Password:
If \"%password%\"==\"null\" goto login_decrypt_failure
set Rand_Captcha=%random%
echo.
Set /p captcha=       Verification code[%Rand_Captcha%]:
if %Rand_Captcha%==%captcha% goto login_decrypt
goto login_decrypt_failure

:verify_device
::Save password
del %temp%\login_pass.sfla
echo.%md5_password%>%temp%\login_pass.sfla
::Obtain device information when registering an account
move "%temp%\%md5_uid%.key" "%temp%\%md5_uid%.txt"
for /f "delims== tokens=1*" %%a in ('type "%temp%\%md5_uid%.txt" ^|C:\Windows\System32\findstr /i "machinekey"') do set s_machinekey=%%b
wmic cpu get ProcessorId /format:textvaluelist.xsl >$
for /f "delims== tokens=1*" %%a in ('type $ ^|C:\Windows\System32\findstr /i "ProcessorId"') do set machinekey=%%b
del $
if %machinekey%==%s_machinekey% goto device_success
del %temp%\%md5_uid%.txt
goto device_failure

:device_failure
cls
echo.
echo.      SFLA Login Launcher - Sorry
echo.   ___________________________________________________________
echo.
echo.
echo.      This account cannot be logged in on this device.
echo.
echo.      Press any key to login again...
pause>nul
goto login_uid

:device_success
cls
::Login and verify success
goto success

:success
cls
echo.
echo.      SFLA Login Launcher
echo.   ___________________________________________________________
echo.
echo.
echo.      Login successful.
echo.
echo.      Press any key to exit...
pause>nul
exit
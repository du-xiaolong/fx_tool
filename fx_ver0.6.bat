@echo off
title=fx 0.7 �ֻ�δ����
chcp 936
color f0
mode con cols=60 lines=15
::echo   author:duxiaolong date:2018-6-25 10:49:27 ver 0.6
d:
if not exist d:\fx md d:\fx
cd d:\fx
echo.
echo �ȴ��豸����
adb wait-for-device
cls
echo ����Ѱ���豸....
:lp
set "ph=fx.log"
adb devices > "%ph%"
find /i "device" < "%ph%" && goto :success
goto :lp
:success
del fx.log
cls
echo **�ֻ�������**
title=fx 0.7 �ֻ�������
goto :begin
:begin
echo.
echo ��1���������ݰ�    ��2��ɾ�����ݰ� ��3��ж�س���
echo ��4��ɾ��crash     ��5����ͼ       ��6������crash 
echo ��7����װapk       ��8���汾��Ϣ   ��9���������ݰ�
echo ��0����������
echo.
:0
echo.
set order=
set /p order=�������
set devices=
cls
if "%order%"=="" goto begin
if %order%==0 goto reconnect
if %order%==1 goto 1
if %order%==2 goto 2
if %order%==3 goto 3
if %order%==5 goto 5
if %order%==6 goto 6
if %order%==7 goto 7
if %order%==4 goto 4
if %order%==8 goto 8
if %order%==9 goto 9 
if %order%==s goto s 
goto begin
:1
if exist com.liankai.fenxiao rd/s/q com.liankai.fenxiao
md com.liankai.fenxiao 
adb pull /sdcard/com.liankai.fenxiao/Config.xml com.liankai.fenxiao
adb pull /sdcard/com.liankai.fenxiao/PrivateConfig.xml com.liankai.fenxiao 
adb pull /sdcard/com.liankai.fenxiao/databases com.liankai.fenxiao
::echo %errorlevel%
if %errorlevel%==0 (
    echo ������ɣ�
    explorer D:\fx\com.liankai.fenxiao
) else ( 
    echo ����ʧ�ܣ� 
)
goto begin
:2
adb shell am force-stop com.liankai.fenxiao
adb shell rm -r /sdcard/com.liankai.fenxiao
if %errorlevel%==0 ( echo ɾ����ɣ�) else ( echo ɾ��ʧ�ܣ�) 
goto begin
:3
adb uninstall com.liankai.fenxiao
echo ж����ɣ�
goto begin
:4
adb shell rm -r /sdcard/crash
echo ɾ����ɣ�
goto begin
:5
set lj=%date:~,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.png
set lj=%lj: =0% 
adb shell screencap -p /sdcard/%lj%
if not exist screenshots md screenshots 
adb pull /sdcard/%lj% screenshots
adb shell rm -r /sdcard/%lj%
echo.
D:\fx\screenshots\%lj%
goto begin
:6
rd/s/q crash 
adb pull /sdcard/crash
if %errorlevel%==0 (
  echo ������ɣ�
  explorer D:\fx\crash
) else echo ����ʧ�ܣ�
goto begin
:7
adb uninstall com.liankai.fenxiao
setlocal ENABLEDELAYEDEXPANSION
set var= 
for %%i in (*.apk) do ( 
     set var=%%i
     echo ���ڰ�װ%%i
     goto install
    ) 
echo δ�ҵ�Fenxiao��װ����
goto begin
:install
adb install -r %var%
echo %var%��װ�ɹ�
adb shell am start -n com.liankai.fenxiao/com.liankai.fenxiao.activity.FrmMaster_
goto begin
:8
chcp 65001
cls
adb shell dumpsys package com.liankai.fenxiao | findstr version
adb shell cat /system/build.prop>%~dp0\phone.info
FOR /F "tokens=1,2 delims==" %%a in (phone.info) do (
 IF %%a == ro.build.version.release SET androidOS=%%b
 IF %%a == ro.product.model SET model=%%b
 IF %%a == ro.product.brand SET brand=%%b
)
del /a/f/q %~dp0\phone.info
echo.
ECHO     Device: %brand% %model% (Android %androidOS%)

pause>nul
chcp 936
cls
goto begin
:9
::�������ݰ�
if exist com.liankai.fenxiao ( 
   adb shell am force-stop com.liankai.fenxiao
   adb shell rm -r /sdcard/com.liankai.fenxiao 
   adb push com.liankai.fenxiao /sdcard/
   adb shell am start -n com.liankai.fenxiao/com.liankai.fenxiao.activity.FrmMaster_
   echo ����ɹ���
 ) else ( 
  echo com.liankai.fenxiao�ļ��в����ڣ�
)
goto begin
:s
adb devices
setlocal enabledelayedexpansion
set /p devices=input deviceid��
pause
:reconnect
cls
echo �ȴ��豸����
title=fx 0.7 �ֻ�δ����
adb kill-server
adb wait-for-device
cls
echo ����Ѱ���豸....
goto :lp


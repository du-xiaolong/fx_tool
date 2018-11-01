@echo off
title=fx 0.7 手机未连接
chcp 936
color f0
mode con cols=60 lines=15
::echo   author:duxiaolong date:2018-6-25 10:49:27 ver 0.6
d:
if not exist d:\fx md d:\fx
cd d:\fx
echo.
echo 等待设备连接
adb wait-for-device
cls
echo 正在寻找设备....
:lp
set "ph=fx.log"
adb devices > "%ph%"
find /i "device" < "%ph%" && goto :success
goto :lp
:success
del fx.log
cls
echo **手机已连接**
title=fx 0.7 手机已连接
goto :begin
:begin
echo.
echo 【1】导出数据包    【2】删除数据包 【3】卸载程序
echo 【4】删除crash     【5】截图       【6】导出crash 
echo 【7】安装apk       【8】版本信息   【9】导入数据包
echo 【0】重新连接
echo.
:0
echo.
set order=
set /p order=输入命令：
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
    echo 导出完成！
    explorer D:\fx\com.liankai.fenxiao
) else ( 
    echo 导出失败！ 
)
goto begin
:2
adb shell am force-stop com.liankai.fenxiao
adb shell rm -r /sdcard/com.liankai.fenxiao
if %errorlevel%==0 ( echo 删除完成！) else ( echo 删除失败！) 
goto begin
:3
adb uninstall com.liankai.fenxiao
echo 卸载完成！
goto begin
:4
adb shell rm -r /sdcard/crash
echo 删除完成！
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
  echo 导出完成！
  explorer D:\fx\crash
) else echo 导出失败！
goto begin
:7
adb uninstall com.liankai.fenxiao
setlocal ENABLEDELAYEDEXPANSION
set var= 
for %%i in (*.apk) do ( 
     set var=%%i
     echo 正在安装%%i
     goto install
    ) 
echo 未找到Fenxiao安装包！
goto begin
:install
adb install -r %var%
echo %var%安装成功
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
::导入数据包
if exist com.liankai.fenxiao ( 
   adb shell am force-stop com.liankai.fenxiao
   adb shell rm -r /sdcard/com.liankai.fenxiao 
   adb push com.liankai.fenxiao /sdcard/
   adb shell am start -n com.liankai.fenxiao/com.liankai.fenxiao.activity.FrmMaster_
   echo 导入成功！
 ) else ( 
  echo com.liankai.fenxiao文件夹不存在！
)
goto begin
:s
adb devices
setlocal enabledelayedexpansion
set /p devices=input deviceid：
pause
:reconnect
cls
echo 等待设备连接
title=fx 0.7 手机未连接
adb kill-server
adb wait-for-device
cls
echo 正在寻找设备....
goto :lp


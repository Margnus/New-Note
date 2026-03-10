@echo off
REM Flutter 初始化脚本

echo ============================================
echo Flutter 初始化和配置脚本
echo ============================================
echo.

REM 设置 Flutter 路径
set FLUTTER_PATH=C:\tools\flutter
set PATH=%FLUTTER_PATH%\bin;%PATH%

echo [1/5] 检查 Flutter 版本...
echo.
call flutter --version
if errorlevel 1 (
    echo 错误: Flutter 版本检查失败
    pause
    exit /b 1
)
echo.

echo [2/5] 运行 Flutter Doctor...
echo.
call flutter doctor
echo.

echo [3/5] 安装依赖...
echo.
cd /d E:\work\StudioProjects\kpm
call flutter pub get
if errorlevel 1 (
    echo 警告: 依赖安装可能失败，请手动检查
)
echo.

echo [4/5] 生成代码...
echo.
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo 警告: 代码生成可能失败，请手动检查
)
echo.

echo [5/5] 检查可用设备...
echo.
call flutter devices
echo.

echo ============================================
echo 初始化完成！
echo ============================================
echo.
echo 下一步：
echo 1. 确保 Android 模拟器正在运行
echo 2. 运行: flutter run
echo.
pause

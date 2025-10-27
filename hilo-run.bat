@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

set "PORTS=56789 5050 6060 7070 8080 9090 6789"
set "PORT="
:menu
cls
echo Chào mừng đến với công ty cổ phần dịch vụ T-VAN HILO
echo Phần mềm hỗ trợ ký số T-VAN HILO giúp bạn ký số an toàn cho hóa đơn điện tử, văn bản, tài liệu.
echo © 2025 Công ty cổ phần dịch vụ T-VAN HILO. All rights reserved.
echo CÔNG TY CP DỊCH VỤ T-VAN HILO
echo Địa chỉ: Tầng 4 số 6 ngõ 95 Chùa Bộc, P.Quang Trung, Hà Nội
echo Điện thoại: 1900 2929 62
echo Email: cskh@hilo.com.vn
echo Website: https://hilo.com.vn
echo Website kiểm tra ký số: https://hilogroup.github.io
echo ================== MENU ==================
echo 1. Kiem tra TCP ports ^(%PORTS%^) + Process
echo 2. Liet ke tat ca certificates (CurrentUser\My)
echo 3. Tra cuu theo từng port
echo 4. Thoat
echo ==========================================
choice /C 1234 /N /M "Chon [1-4]: "
set "pick=%errorlevel%"

if "%pick%"=="1" goto tcp
if "%pick%"=="2" goto cert_my_person
if "%pick%"=="3" goto lookup_port
if "%pick%"=="4" goto end

goto menu

:tcp
echo.
echo Checking for active processes on ports: %PORTS%
echo.
echo =========================================================================
echo Port^|^| Protocol^|^| Local Address^|^| State^|^| PID^|^| Process Name
echo =========================================================================

for %%P in (%PORTS%) do (

echo ==========================Port[%%P]======================================
  netstat -ano | findstr /R "%%P"  
  echo Checking port: %%P
    :: Chạy netstat và lọc theo cổng %%P
    set "FOUND_PID="
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr /R ":%%P"') do (
        set "FOUND_PID=%%a"
        echo PID for port %%P: !FOUND_PID!
        :: Lấy tên tiến trình từ PID
        set "PROCESS_NAME="
        for /f "tokens=1" %%b in ('tasklist /FI "PID eq !FOUND_PID!" /FO CSV ^| findstr /R "."') do (
            set "PROCESS_NAME=%%b"
        )
        :: Kiểm tra lỗi hoặc không tìm thấy tiến trình
        if "!PROCESS_NAME!"=="" (
            echo Error: No process found for PID !FOUND_PID! or an error occurred.
        ) else (
            :: Loại bỏ dấu ngoặc kép từ tên tiến trình
            set "PROCESS_NAME=!PROCESS_NAME:"=!"
            echo Process name for PID !FOUND_PID!: !PROCESS_NAME!
        )
    )
    :: Kiểm tra nếu không tìm thấy PID cho cổng
    if "!FOUND_PID!"=="" (
        echo Error: No PID found for port %%P.
    )
  echo =========================================================================
)
pause
goto menu


:cert_my_person
echo ============= Certificates: CurrentUser\My =============
certutil -store -user My
echo ===============================================
pause
goto menu


:lookup_port
set /p PORT="Nhap so cong (vd 8080): "
if "!PORT!"=="" goto menu
  netstat -ano | findstr /R "%PORT%"  
echo Checking port: %PORT%
    :: Chạy netstat và lọc theo cổng %PORT%
    set "FOUND_PID="
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr /R ":%PORT%"') do (
        set "FOUND_PID=%%a"
        echo PID for port %PORT%: !FOUND_PID!
        :: Lấy tên tiến trình từ PID
        set "PROCESS_NAME="
        for /f "tokens=1" %%b in ('tasklist /FI "PID eq !FOUND_PID!" /FO CSV ^| findstr /R "."') do (
            set "PROCESS_NAME=%%b"
        )
        :: Kiểm tra lỗi hoặc không tìm thấy tiến trình
        if "!PROCESS_NAME!"=="" (
            echo Error: No process found for PID !FOUND_PID! or an error occurred.
        ) else (
            :: Loại bỏ dấu ngoặc kép từ tên tiến trình
            set "PROCESS_NAME=!PROCESS_NAME:"=!"
            echo Process name for PID !FOUND_PID!: !PROCESS_NAME!
        )
    )
    :: Kiểm tra nếu không tìm thấy PID cho cổng
    if "!FOUND_PID!"=="" (
        echo Error: No PID found for port %PORT%.
    )
pause
goto menu


:end
echo Thoat.
endlocal
exit /b

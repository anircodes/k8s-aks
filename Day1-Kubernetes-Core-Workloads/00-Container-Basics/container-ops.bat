@echo off
echo Container Operations Script

:menu
echo.
echo 1. Check Docker Status
echo 2. Build Custom Container
echo 3. Run Container
echo 4. Stop Container
echo 5. View Logs
echo 6. Clean Up
echo 7. Exit
echo.

set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto check_status
if "%choice%"=="2" goto build_container
if "%choice%"=="3" goto run_container
if "%choice%"=="4" goto stop_container
if "%choice%"=="5" goto view_logs
if "%choice%"=="6" goto cleanup
if "%choice%"=="7" goto end

:check_status
echo.
echo Checking Docker status...
docker --version
docker ps
goto menu

:build_container
echo.
echo Building custom container...
docker build -t my-custom-nginx .
goto menu

:run_container
echo.
echo Running container...
docker run -d -p 8080:80 --name my-nginx my-custom-nginx
echo Container started. Visit http://localhost:8080
goto menu

:stop_container
echo.
echo Stopping container...
docker stop my-nginx
goto menu

:view_logs
echo.
echo Container logs:
docker logs my-nginx
goto menu

:cleanup
echo.
echo Cleaning up resources...
docker stop my-nginx 2>nul
docker rm my-nginx 2>nul
docker system prune -f
goto menu

:end
echo.
echo Exiting...
exit /b 0

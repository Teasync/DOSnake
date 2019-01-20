@echo off
setlocal enabledelayedexpansion enableextensions
cls
echo ]2;Snake[?25l

for /l %%i in (1,1,16) do (
	for /l %%j in (1,1,16) do (
		set x_coord=%%j
		set y_coord=%%i
		set "grid%%j-%%i=0"
	)
)

call :drawBorders

set "curr_x=5"
set "curr_y=5"
REM set "last_x[1]=!curr_x!"
REM set "last_y[1]=!curr_y!"
set "currdir=w"
set bodySize=4
set /a bodySizeLess=bodySize-1

set "ctr=!bodySizeLess!"
:while1
if "!ctr!"=="0" goto endwhile1

	set "last_x[!ctr!]=5"
	set "last_y[!ctr!]=5"

set /a ctr-=1
:endwhile1

:while
	set "choiceStr="
	
	if !currdir!==w set choiceStr=wapd
	if !currdir!==s set choiceStr=pasd
	if !currdir!==a set choiceStr=wasp
	if !currdir!==d set choiceStr=wpsd
	
	choice /c !choiceStr! /N /T 1 /d !currdir! > nul

	set "ctr=!bodySizeLess!"
		:while2
			if "!ctr!"=="0" goto endwhile2
				
				set /a prev=ctr+1
				for /f "tokens=1,2" %%a in ("!prev! !ctr!") do set "last_x[%%a]=!last_x[%%b]!" & echo [22;1Hlast_x[%%a]=!last_x[%%b]!
				for /f "tokens=1,2" %%a in ("!prev! !ctr!") do set "last_y[%%a]=!last_y[%%b]!" & echo [23;1Hlast_y[%%a]=!last_x[%%b]!
				echo !ctr!
			set /a ctr-=1
			goto while2
		:endwhile2

	set "last_x[1]=!curr_x!"
	set "last_y[1]=!curr_y!"

	if "%errorlevel%"=="1" (
		if "!currdir!"=="s" (
			goto s
		)
		goto w
	)
	if "%errorlevel%"=="2" (
		if "!currdir!"=="d" (
			goto d
		)
		goto a
	)
	if "%errorlevel%"=="3" (
		if "!currdir!"=="w" (
			goto w
		)
		goto s
	)
	if "%errorlevel%"=="4" (
		if "!currdir!"=="a" (
			goto a
		)
		goto d
	)

	:s
	set "currdir=s"
	set /a curr_y+=1
	if !curr_y! gtr 16 set curr_y=1
	goto endswitch
	:a
	set "currdir=a"
	set /a curr_x-=1
	if !curr_x! lss 1 set curr_x=16
	goto endswitch
	:w
	set "currdir=w"
	set /a curr_y-=1
	if !curr_y! lss 1 set curr_y=16
	goto endswitch
	:d
	set "currdir=d"
	set /a curr_x+=1
	if !curr_x! gtr 16 set curr_x=1
	goto endswitch
	:endswitch

	echo [20;1H!curr_x!	!curr_y!
	
	echo [21;1H!last_x[%bodySize%]!	!last_y[%bodySize%]!
	call :putSnakeChunk !curr_x! !curr_y!
	call :eraseChunk !last_x[%bodySize%]! !last_y[%bodySize%]!
	call :drawBoard

goto while
:endwhile

for /l %%i in (12,-1,4) do (
	set "grid%%i-3=1"
	set /a last=%%i-1
	REM set "grid!last!-3=0"
	call :drawBoard
	sleep -m 500
)
for /l %%i in (12,-1,4) do (
	set "grid%%i-3=0"
	set /a last=%%i-1
	REM set "grid!last!-3=0"
	call :drawBoard
	sleep -m 500
)

echo [20;1H & pause
cls
exit /b

:putChunk
setlocal enabledelayedexpansion
endlocal
set "grid%~1-%~2=%~3"
exit /b

:putSnakeChunk
call :putChunk %~1 %~2 1
exit /b

:eraseChunk
call :putChunk %~1 %~2 0
exit /b

:drawBorders
setlocal enabledelayedexpansion
for /l %%i in (1,1,18) do (
	if "%%i"=="1" echo [1;1H(0lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk(B
	if "%%i"=="18" echo [18;1H(0mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj(B
	for /l %%j in (1,1,18) do (
		if "%%j"=="1" if %%i geq 2 if %%i leq 17 echo [%%i;1H(0x(B
		if "%%j"=="18" if %%i geq 2 if %%i leq 17 echo [%%i;36H(0x(B
	)
)

exit /b

:drawBoard
setlocal enabledelayedexpansion
for /l %%i in (1,1,18) do (
	for /l %%j in (1,1,18) do (
		set /a x_coord=%%j*2+1
		set /a y_coord=%%i+1
		if "!grid%%j-%%i!"=="1" echo [!y_coord!;!x_coord!H[107m  [0m
		if "!grid%%j-%%i!"=="0" echo [!y_coord!;!x_coord!H[2X[0m  
		)
	)
)

exit /b
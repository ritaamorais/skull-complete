@setlocal enableextensions enabledelayedexpansion
@echo off

if "%~1"=="" (
	echo BrainSuite v17a Cortical Surface Extraction Script
  echo Authored by David W Shattuck http://shattuck.bmap.ucla.edu
  echo UCLA Brain Mapping Center
  echo For more information, please see: http://brainsuite.org
	echo usage: %~0 input_image
  echo where input_image is a raw MRI file, in .nii, .img, .nii.gz, or .img.gz format.
	exit /b 0
  )
echo BrainSuite v15c Cortical Surface Extraction Script
echo Authored by David W Shattuck http://shattuck.bmap.ucla.edu
echo UCLA Brain Mapping Center
echo for more information, please see: http://brainsuite.org

for %%? in ("%~dp0..") do set BrainSuitePath=%%~f?
set BrainSuiteBinDir="%~dp0"
if not exist "%BrainSuitePath%\bin\bse.exe" (
rem if you copy the script to another directory, you will want to set these locations to wherever BrainSuite is installed
echo could not find BrainSuite files... trying default install location C:\Program Files\BrainSuite17a\
set BrainSuitePath=F:\BrainSuite17a
set BrainSuiteBinDir="F:\BrainSuite17a\bin\"
)
if not exist "%BrainSuitePath%\bin\bse.exe" (
echo Could not find BrainSuite binaries. Quitting...
exit /b 1
)
echo ----------
echo BrainSuite is in %BrainSuitePath%\
echo Bin is %BrainSuiteBinDir%
echo ----------

echo Using BrainSuite binaries and data in %BrainSuitePath%

set basename=%1
rem remove any quotes from the string
set basename=%basename:"=%
rem remove img, img.gz, nii, nii.gz, hdr, etc.
if "x!basename:~-3!"=="x.gz" ( set basename=!basename:~0,-3!)
if "x!basename:~-4!"=="x.hdr" ( set basename=!basename:~0,-4!)
if "x!basename:~-4!"=="x.img" ( set basename=!basename:~0,-4!)
if "x!basename:~-4!"=="x.nii" ( set basename=!basename:~0,-4!)
rem add quotes in case there are spaces inside the string
set basename="%basename%"
rem change EXT to produce different outputs, e.g., uncompressed nifti
set EXT=nii.gz

echo working with basename: %basename%

@rem A few example variables that can be set. These settings match the ones in the GUI.
@rem use the VERBOSE flag to change the output option for all of the programs
@rem set VERBOSE=-v 1 --timer
@rem These values are set to match the defaults used in the GUI version of BrainSuite15b
set BSEOPTIONS=-n 3 -d 25 -s 0.64 -p --trim --auto
set SKULLFINDEROPTIONS=-s %basename% --finalOpening
@rem set PVCOPTIONS="-l 0.1"
set ATLAS=%BrainSuitePath%\atlas\brainsuite.icbm452.lpi.v08a.img
set ATLASLABELS=%BrainSuitePath%\atlas\brainsuite.icbm452.v15a.label.img
set ATLASES=--atlas "%ATLAS%" --atlaslabels "%ATLASLABELS%"
@rem set CEREBROOPTIONS="--centroids"

@rem you can specify an options file in the directory from which you launch the script
@rem Read from the BrainSuiteOptions file if it exists: strip out any double quotes and set variables accordingly
if exist BrainSuiteOptions (
echo Reading BrainSuite extraction settings from BrainSuiteOptions file
for /f "tokens=*" %%a in (BrainSuiteOptions) do (
	set z=%%a
	set z=!z:"=!
	echo !z!
	set !z!
)
)
echo ---- Running BrainSuite Cortical Surface Extraction Sequence ----
@rem 1. bse
%BrainSuiteBinDir%bse %VERBOSE% -i %1 -o %basename%.bse.%EXT% --hires %basename%.hires_mask.%EXT% %BSEOPTIONS%

if %ERRORLEVEL% NEQ 0 ( echo cortical extraction halted because BSE failed to run. && exit /b 1 )

@rem 2. skullfinder
%BrainSuiteBinDir%skullfinder %VERBOSE% -i %1 -o %basename%.skullfinder.%EXT% -m %basename%.hires_mask.%EXT% %SKULLFINDEROPTIONS%

if %ERRORLEVEL% NEQ 0 ( echo cortical extraction halted because BSE failed to run. && exit /b 1 )


exit /b 0


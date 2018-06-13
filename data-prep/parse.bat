@echo off

rem For each file in your folder
for /d %%a in ("E:\hcp-openaccess\HCP_1200\*") do (

rem name + folder path
echo %%a
rem only name
echo %%~na

rem mkdir "C:\Temp\%%~na"

rem copy "E:\hcp-openaccess\HCP_1200\100206\T1w\100206\mri\T1w_hires.nii.gz" "C:\Temp\100206"
rem rename "C:\Temp\100206\T1w_hires.nii.gz" "T1w_hires100206.nii.gz"

rem copy "E:\hcp-openaccess\HCP_1200\%%~na\T1w\%%~na\mri\T1w_hires.nii.gz" "C:\Temp\%%~na"
rem copy "E:\hcp-openaccess\HCP_1200\%%~na\T1w\%%~na\mri\T1w_hires.nii.gz" "C:\Temp\"
rem rename "C:\Temp\T1w_hires.nii.gz" "T1w_hires%%~na.nii.gz"

copy "E:\hcp-openaccess\HCP_1200\%%~na\T1w\%%~na\mri\T1w_hires.nii.gz" "G:\Connectome\"
rename "G:\Connectome\T1w_hires.nii.gz" "T1w_hires%%~na.nii.gz"

)

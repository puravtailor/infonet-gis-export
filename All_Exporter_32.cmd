cls

@echo %date% %time% "Archiving and deleting GDB"

rem C:\Python27\ArcGIS10.5\python.exe "G:\Information Directorate\InfoNet Scripting\InfoNet Exports for GIS FME Transform\Auto-Scripting-Infonet-ArcGIS\DeleteGDBs.py"

@echo %date% %time% "Completed"


@echo %date% %time% "Exporting from InfoNet to GDB"

"C:\Program Files\Innovyze Workgroup Client 7.5\iexchange.exe" "G:\Information Directorate\InfoNet Scripting\InfoNet Exports for GIS FME Transform\Auto-Scripting-Infonet-ArcGIS\Infonet-ArcGIS.rb" /IN

@echo %date% %time% "Completed"

cmd
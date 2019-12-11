db = WSApplication.open('10.249.30.6:40000/Infonet_PIMS',false)

# Required to tell IExchange to use the desktop licence and not ArcServer licence
WSApplication.use_arcgis_desktop_licence

# Create an array of the networks you want to connect to and a label for them.
read_file = open("G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\network\\colnw.txt","r")
read_file1 = open("G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\network\\distnw.txt","r") #Read all the networks text file specified seperated by commas
lines = read_file.read().split(',')
lines1 = read_file1.read().split(',')
moc=db.model_object_collection(lines[0]) #first string in networks file which is collection network
moc1=db.model_object_collection(lines1[0]) #second string in networks file which is distribution network
begin 
moc.each do |y| #loop over all collection network objects
$x = 0
while $x <= lines.length do 
	$x += 1
	colnet = Array[]
	table_description = Array[]
	colnet = y.name
	if colnet == lines[$x]
	colnw = db.model_object_from_type_and_id(lines[0],y.id) 
	colnw.update
	nw1= colnw.current_commit_id
	$y =0
	on= colnw.open
	on.tables.each do |t|
	col_table_name = t.name
	table1= col_table_name.sub("cams_","") 
	col_table_name= table1.gsub("_","")
	#### Not exporting all the tables which have no spatial reference.
	if col_table_name == 'manhole'
	   col_table_name = 'node'
	elsif col_table_name == 'storage'
		 col_table_name = 'storagearea'
	elsif col_table_name == 'ancillary'
		 col_table_name = 'userancillary'
	elsif col_table_name == 'monsurvey'
		  col_table_name = 'monitoringsurvey'
	elsif col_table_name == 'smokedefect'
		 col_table_name = 'smokedefectobservation'
	elsif col_table_name == 'incidentgeneral'	 
		 col_table_name = 'generalincident'
	elsif col_table_name =='incidentcollapse'
		 col_table_name = 'collapseincident'
    elsif col_table_name =='incidentblockage'
		 col_table_name = 'blockageincident'
	elsif col_table_name =='incidentpollution'
		 col_table_name = 'pollutionincident'
	elsif col_table_name =='incidentflooding'
		 col_table_name = 'floodingincident'	 
	elsif col_table_name =='incidentcomplaint'
		 col_table_name = 'customercomplaint'	 
	elsif col_table_name =='incidentodor'
		 col_table_name = 'odorincident'
	elsif col_table_name =='wtw'
		 col_table_name = 'treatmentworks'	  
	elsif col_table_name =='pumpstationem'
		 col_table_name = 'pumpstationelectricalmaintenance'
	elsif col_table_name =='pumpstationmm'
		 col_table_name = 'pumpstationmechanicalmaintenance'	 
		else ''
	end

    gdb_options = {
    'Callback Class' => nil,
    'Image Folder' => '',
    'Units Behaviour' => 'Native',
    'Report Mode' => true,
    'Export Selection' => false,
    'Previous Version' => 0,
    'Error File' => "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Errorlogs\\Exporterrorlog.txt",
	#'Connection File' => "\\\10.0.27.147\\resources\\system\\ArcGIS\\mastergis_SDEADMIN_db.prod.arcgis.wellingtonwater.cloud.sde",
    }

    #This exports all the Councils into a single GDB. See Export Filename.
   if col_table_name != 'resource' && col_table_name != 'material' && col_table_name != 'approvallevel' && col_table_name != 'order' && col_table_name != 'namegroupnode' && col_table_name != 'namegrouppipe' && col_table_name != 'namegroupconnectionpipe'
    print "Exporting InfoNet table '#{col_table_name}' to GDB feature class '#{colnet}_#{col_table_name}' in ALL GDB"
	begin
    colnw.odec_export_ex(
      'GDB',
      "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\All_DRN.cfg",
      gdb_options,
      # Table to export from InfoNet. Pulls from list of table names
      col_table_name,
      # Feature class name, currently uses the same value as InfoNet table
      colnet + '_' + col_table_name,
      # Feature dataset, currently uses the 'key' in the networks array
      colnet,
      #4- Update – true to update, false otherwise. If true the feature class must exist.
      false,
      #5- ArcSDE configuration keyword – nil for Personal / File GeoDatabases, and ignored for updates
      nil,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
      'G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Output\\All_InfoNet_Export.gdb'#'\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb'#\\\10.0.27.147\\resources\\system\\ArcGIS\\All_InfoNet_Export.gdb,','\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb'#
      )
	  rescue
      puts
      puts " - EXPORTED WITH ERRORS, Check Error File"
      puts
    else
      puts
      print '- Done'
      puts
    end 
    puts
	end
    end
    end  
	end
	end
end
	
	
begin 
moc1.each do |z| #loop over all distribution network objects
$x = 0
while $x <= lines1.length do 
	$x += 1
	distnet = Array[]
	distnet = z.name
	if distnet == lines1[$x]
	distnw = db.model_object_from_type_and_id(lines1[0],z.id)
	distnw.update
	dist_nw= distnw.current_commit_id
	on= distnw.open
	on.tables.each do |t|
	dist_table_name = t.name
	table1= dist_table_name.sub("wams_","")
	dist_table_name= table1.gsub("_","") 
	if dist_table_name == 'monsurvey'
		dist_table_name = 'monitoringsurvey'
	elsif dist_table_name =='wtw'
		dist_table_name = 'treatmentworks'	
	elsif dist_table_name == 'incidentgeneral'	 
			dist_table_name = 'generalincident'
	elsif dist_table_name =='incidentburst'
		 dist_table_name = 'burstincident'
    elsif dist_table_name =='incidentwq'
		 dist_table_name = 'waterqualityincident'
	elsif dist_table_name =='incidentpollution'
		 dist_table_name = 'pollutionincident'
	elsif dist_table_name =='incidentflooding'
		 dist_table_name = 'floodingincident'	 
	elsif dist_table_name =='incidentcomplaint'
		 dist_table_name = 'customercomplaint'	 
	elsif dist_table_name =='incidentodor'
		 dist_table_name = 'odorincident'
	elsif dist_table_name =='wtw'
		 dist_table_name = 'treatmentworks'	  
	elsif dist_table_name =='pumpstationem'
		 dist_table_name = 'pumpstationelectricalmaintenance'
	elsif dist_table_name =='pumpstationmm'
		 dist_table_name = 'pumpstationmechanicalmaintenance'
	end
	
    gdb_options = {
    'Callback Class' => nil,
    'Image Folder' => '',
    'Units Behaviour' => 'Native',
    'Report Mode' => true,
    'Export Selection' => false,
    'Previous Version' => 0,
    'Error File' => "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Errorlogs\\Exporterrorlog.txt"
    }

    #This exports all the Councils into a single GDB. See Export Filename.

   if dist_table_name != 'resource' && dist_table_name != 'material' && dist_table_name != 'approvallevel' && dist_table_name != 'order' && dist_table_name != 'namegroupnode' && dist_table_name != 'namegrouppipe' 
    print "Exporting InfoNet table '#{dist_table_name}' to GDB feature class '#{distnet}_#{dist_table_name}' in ALL GDB"
begin   
   distnw.odec_export_ex(
    'GDB',
      "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\All_PW.cfg",
	  gdb_options,
      # Table to export from InfoNet. Pulls from list of table names
	  dist_table_name,
	  # Feature class name, currently uses the same value as InfoNet table
      distnet + '_' + dist_table_name,
      # Feature dataset, currently uses the 'key' in the networks array
      distnet,
      #4- Update – true to update, false otherwise. If true the feature class must exist.
      false,
      #5- ArcSDE configuration keyword – nil for Personal / File GeoDatabases, and ignored for updates
      nil,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
      'G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Output\\All_InfoNet_Export.gdb'#'\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb'#\\\10.0.27.147\\resources\\system\\ArcGIS\\All_InfoNet_Export.gdb,','\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb'#'G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Output\\All_InfoNet_Export.gdb'
      )
	  #Uncomment this to skip over errors    
	  rescue
      puts
      puts " - EXPORTED WITH ERRORS, Check Error File"
      puts
    else
      puts
      print '- Done'
      puts
    end 
	puts
	end
	end
	end
	end
	end
	end
 

   
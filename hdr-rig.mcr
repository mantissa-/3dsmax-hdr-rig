-- HDR Rig 1.0 - 06/02/15
-- Developed by Midge Sinnaeve
-- www.themantissa.net
-- midge@daze.tv
-- Licensed under GPL v2

macroScript HDRRig
	category:"DAZE"
	toolTip:"Set up a quick HDR Rig"
	buttonText:"HDR Rig"
	(
		try(destroyDialog ::HDRRig)catch()
		rollout HDRRig "HDR Rig" width:250 height:305
		(
			-- INTERFACE --
			
			button btn_version "HDR Rig" pos:[195,5] width:50 height:17 border:false
			
			label lbl_map "Select HDR Map:" pos:[5,5] width:100 height:15
			edittext txt_map "" pos:[0,24] width:210 height:20
			button btn_map "..." pos:[216,24] width:30 height:20
			
			checkbox chk_sky "Create Skylight" pos:[5,55] width:100 height:20 enabled:true checked:true
			spinner spn_intensity "Intensity: " pos:[150,55] width:95 height:16 range:[0.0,1e+008,1.0]
			
			GroupBox grp_ctrl "Bitmap Controls" pos:[5,80] width:240 height:150
				
				label lbl_rot "Sun Position (Top View)" pos:[15,100] width:125 height:15
				angle ang_rot "" pos:[35,125] align:#center startdegrees:-90 dir:#ccw diameter:64 color:orange
				checkbox chk_fliphor "Flip Horizontal" pos:[140,95] width:90 height:20 checked:true
				checkbox chk_flipver "Flip Vertical" pos:[140,120] width:90 height:20
				spinner spn_tileu "Tile U: " pos:[160,155] width:75 height:16 range:[0.0,10000.0,1.0]
				spinner spn_tilev "Tile V: " pos:[160,180] width:75 height:16 range:[0.0,10000.0,1.0]
				checkbox chk_rothelp "Create Rotation Helper" pos:[15,205] width:135 height:20 enabled:true checked:true
			
			checkbox chk_bg "Enable Viewport Background Preview" pos:[25,240] width:200 height:20 enabled:true checked:true
			
			button btn_create "CREATE RIG" pos:[5,265] width:240 height:35
			
			
			-- FUNCTIONS --
			
			fn createRig =
			(
				rot_nrml = (ang_rot.degrees / 360); rot_full = ang_rot.degrees
				tileu = if chk_fliphor.checked == true  then - (spn_tileu.value) else spn_tileu.value
				tilev = if chk_flipver.checked == true  then - (spn_tilev.value) else spn_tilev.value
				
				envi_bmp = Bitmaptexture name:"HDR Environment" filename:txt_map.text
				envi_bmp.coords.U_Tiling = tileu; envi_bmp.coords.V_Tiling = tilev
				envi_bmp.coords.U_Offset = rot_nrml
				environmentMap = envi_bmp
				useEnvironmentMap = true
				if chk_bg.checked == true do actionMan.executeAction 0 "619"
				
				if chk_sky.checked == true do 
				(
					sky = Skylight multiplier:spn_intensity.value sky_mode:0 name:(uniquename "HDR Skylight ")
					paramWire.connect2Way sky.baseObject[#Multiplier] envi_bmp.output[#Output_Amount] "Output_Amount" "Multiplier"
				)
				
				if chk_rothelp.checked == true do
				(
					rothelp = sliderManipulator xPos:0.875 yPos:0.95 isSelected:on name:(uniquename "HDR Rotation Slider ") sldName: "HDR Map U Offset" minVal:0 maxVal:1.001 snapVal:0.001
					paramWire.connect2Way envi_bmp.coords[#U_Offset] rothelp.baseObject[#value] "value" "U_Offset"
				)
			)
			
			-- ACTIONS --
			
			on btn_map pressed do txt_map.text = getOpenFileName types:"All (*.*)|*.*|"
			
			on btn_create pressed do
			(
				if txt_map.text == "" then 
				(
					messageBox "Please select an HDR."
				)
				else
				(
					with undo off with redraw off createRig()
				)
			)
			
			on btn_version pressed do messageBox "HDR Rig 1.0 - 06/02/15 \n\nDev by Midge Sinnaeve \nwww.themantissa.net \nmidge@daze.tv \nFree for all use and / or modification. \nIf you modify the script, please mention my name, cheers. :)" title:"About HDR Rig" beep:false
		)
		createDialog HDRRig 250 305 50 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	)

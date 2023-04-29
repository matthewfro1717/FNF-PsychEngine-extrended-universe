--Script made by Super_Hugo on Gamebanana


---IF YOUR SPRITE DOESN'T LOAD---

-- If your image is in "mods/YOUR MOD/images" then load into a song from that mod and go to the editor
-- if your image isn't on the "mods/images" folder (example: "assets/images") move the image to that folder or it won't load



---INSTRUCTIONS---

-- 1- Put this script in "mods/scripts" or "assets/scripts" folder (if you don't have one just create it)
-- 2- Go to any song you want
-- 3- Press 9 to go to the stage editor



---ALL CONTROLS---

-- TAB - Save the script

-- Left click - Place object
-- ALT + Left click / Right mouse pressed + Left click - Remove object in front of the cursor
-- SHIFT - Move object in front of the cursor

-- Q / E - Change current property
-- A / D or SPACE - Change value of current property

-- Mouse scroll - Change screen zoom or value of current property if SPACE is pressed
-- Arrow keys - Move screen position

-- ESCAPE - Exit stage editor
-- 9 - Exit stage editor and test saved stage

-- DELETE - Hide stage editor HUD

-- CTRL + Z - Undo last removed object



--NOTE: You can save the stage and press 9 while in the editor to play the current song in the stage you created.
--NOTE 2: If the game lags or crashes when loading the editor it's because it needs to restart the song two times to actually load the stage (in that case go to another song or if it still crashes change loadType to "stage")



----------------------------------OPTIONS----------------------------------
overwriteFile = true		--if a file with same name exists, does it overwrite it?
stopRunningScripts = true		--stops any scripts from running so there aren't any conflicts (RECOMMENDED)

keyboardType = 'european'		--change this to the type of keyboard you use so the typing actually works ('american' / 'european' for now)
useKeyboardControls = false		--change this if you want to use the editor with keyboard instead of mouse

loadType = ''		--if 'empty' loads a blank template stage, if 'stage' loads the song stage (if you want to mess around with the stage or something), anything else loads the fileName stage (saved stage)
saveLastStage = true		--if true saves the last stage you were editing to the fileName variable (for later loading the stage again, if loadType is '' or nil) [could mess up but im not sure, works well for now]

getCurrentStageFolder = false		--if true uses the current stage folder instead of a custom one (example: "mods/MOD/stages") [can be annoying]



------------------VARIABLES (DO NOT CHANGE ANYTHING HERE)------------------

local fileName = 'stage3'
local filePath = 'assets/stages'

local objects = {{}}
local undoObjectsList = {}

--default stuff
local stageData = {directory = '', defaultZoom = 0.9, isPixelStage = 'false', boyfriend = {770, 100}, girlfriend = {400, 130}, opponent = {100, 100}, hide_girlfriend = 'false'}
local objProperties = {name = 'obj', sprite = 'combo', order = 10, camera = 'camGame', scale = 1, alpha = 1, angle = 0, scroll = 1, flipX = 'false', antialiasing = 'true', anim = 1, anims = {}, animated = 'false'}

--for selecting the options
local options = {'sprite', 'order', 'camera', 'scale', 'alpha', 'angle', 'scroll', 'flipX', 'antialiasing', 'anim'}
local curProperty = options[1]
local curPropertyNum = 1

local type = 0
local typedTxt = ''
local inEditor = false
local selected = 0

local objName = ''
local selectedObj = ''
local objPreviewType = 'obj'
local anims = {}

--lmao
local allKeys = {
'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE', 'ZERO',
'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
'Z', 'X', 'C', 'V', 'B', 'N', 'M', 
'MINUS', 'SPACE', 'SLASH'
}

local specialChars = {
'1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
'', '', '', '', '', '', '', '', '', '',
'', '', '', '', '', '', '', '', '',
'', '', '', '', '', '', '',
'-', ' ', '/'
}

local camVarXL = 0
local camVarXR = 0
local camVarYU = 0
local camVarYD = 0



-----------------------------CODE AND STUFF-----------------------------

function onCreate()

	if getPropertyFromClass('PlayState', 'seenCutscene') == true and getPropertyFromClass('PlayState', 'isStoryMode') == false then

		setPropertyFromClass('flixel.FlxG', 'mouse.visible', false)

		makeLuaSprite('cursor', '', getMouseX(objProperties.camera), getMouseY(objProperties.camera))
		makeGraphic('cursor', 15, 15, 'ffffff')
		setObjectCamera('cursor', objProperties.camera)
		addLuaSprite('cursor', true)

		makeLuaSprite('objPreview', '', getMouseX(objProperties.camera), getMouseY(objProperties.camera))
		setObjectCamera('objPreview', objProperties.camera)
		loadGraphic('objPreview', objProperties.sprite)
		addLuaSprite('objPreview', true)

		makeLuaSprite('controlsBG', '', 815, 580)
		makeGraphic('controlsBG', 455, 170, '000000')
		setObjectCamera('controlsBG', 'other')
		addLuaSprite('controlsBG', true)

		makeLuaSprite('propertiesBG', '', 0, 670)
		makeGraphic('propertiesBG', getProperty('controlsBG.x'), 50, '000000')
		setObjectCamera('propertiesBG', 'other')
		addLuaSprite('propertiesBG', true)

		makeLuaText('propertiesTxt', 'Property: Value', 2000, -600, 680)
		setTextSize('propertiesTxt', 25, 25)
		setTextAlignment('propertiesTxt', 'center')
		setObjectCamera('propertiesTxt', 'other')
		addLuaText('propertiesTxt', true)

		makeLuaText('stageTxt', '', 2000, 900, 10)
		setTextSize('stageTxt', 25, 25)
		setTextAlignment('stageTxt', 'left')
		setObjectCamera('stageTxt', 'other')
		addLuaText('stageTxt', true)

		makeLuaText('controlsTxt', '', 2000, 820, 580)
		setTextSize('controlsTxt', 25, 25)
		setTextAlignment('controlsTxt', 'left')
		setObjectCamera('controlsTxt', 'other')
		addLuaText('controlsTxt', true)

		makeLuaSprite('saveBG', '', 0, 0)
		makeGraphic('saveBG', screenWidth, screenHeight, '000000')
		setObjectCamera('saveBG', 'other')
		setProperty('saveBG.visible', false)
		setProperty('saveBG.alpha', 0.7)
		addLuaSprite('saveBG', true)

		makeLuaText('saveTxt', 'Script Name: '..fileName, 2000, 0, 0)
		setTextSize('saveTxt', 40, 40)
		setTextAlignment('saveTxt', 'center')
		setObjectCamera('saveTxt', 'other')
		screenCenter('saveTxt')
		setProperty('saveTxt.y', 180)
		setProperty('saveTxt.visible', false)
		addLuaText('saveTxt', true)

		makeLuaText('savePathTxt', 'Path: '..filePath, 2000, 0, 0)
		setTextSize('savePathTxt', 40, 40)
		setTextAlignment('savePathTxt', 'center')
		setObjectCamera('savePathTxt', 'other')
		screenCenter('savePathTxt')
		setProperty('savePathTxt.y', getProperty('saveTxt.y') + 100)
		setProperty('savePathTxt.visible', false)
		setProperty('savePathTxt.color', getColorFromHex('606060'))
		addLuaText('savePathTxt', true)
		
		makeLuaText('savePixelTxt', '< Pixel Stage: '..stageData.isPixelStage..' >', 2000, 0, 0)
		setTextSize('savePixelTxt', 40, 40)
		setTextAlignment('savePixelTxt', 'center')
		setObjectCamera('savePixelTxt', 'other')
		screenCenter('savePixelTxt')
		setProperty('savePixelTxt.y', getProperty('savePathTxt.y') + 150)
		setProperty('savePixelTxt.visible', false)
		setProperty('savePixelTxt.color', getColorFromHex('606060'))
		addLuaText('savePixelTxt', true)
		
		local confirmTxt = [[
		Press ENTER to save the stage
		
		Press ESCAPE to exit this menu without saving
		]]
		
		makeLuaText('saveConfirmTxt', confirmTxt, 0, 0, screenHeight - 110)
		setTextSize('saveConfirmTxt', 25, 25)
		setTextAlignment('saveConfirmTxt', 'center')
		setObjectCamera('saveConfirmTxt', 'other')
		screenCenter('saveConfirmTxt', 'x')
		setProperty('saveConfirmTxt.visible', false)
		addLuaText('saveConfirmTxt', true)

		if stopRunningScripts == true then

			a = getRunningScripts()
			for i = 1, #a do

				if string.find(a[i], scriptName:sub(-scriptName:reverse():find('/') + 1, -5)) == nil then
					removeLuaScript(a[i])
				end

			end

		end

		inEditor = true

	end

end

function onCreatePost()

	if getPropertyFromClass('PlayState', 'seenCutscene') == true and getPropertyFromClass('PlayState', 'isStoryMode') == false  then
	
		--Warning about file overwrite
		if overwriteFile == true then
			debugPrint('File overwrite is on. ', 'You can turn it off in the lua settings')
		end
		
		--Warning for versions that don't support HScript
		if versionToNumber(getPropertyFromClass("MainMenuState", "psychEngineVersion")) < 61 then
			debugPrint('')
			debugPrint('')
			debugPrint([[
			- Your Psych Engine version can't run HScript. (you need v0.6.1+)
			- Update if you want to load saved stages and modify them.
			]])
			loadType = 'empty'
		end

		--disables the chart/character editors
		setProperty('debugKeysChart', nil)
		setProperty('debugKeysCharacter', nil)

		setProperty('healthBar.visible', false)
		setProperty('healthBarBG.visible', false)
		setProperty('iconP1.visible', false)
		setProperty('iconP2.visible', false)
		setProperty('scoreTxt.visible', false)
		setProperty('timeBar.visible', false)
		setProperty('timeBarBG.visible', false)
		setProperty('timeTxt.visible', false)

		stageData.boyfriend = {getProperty('boyfriend.x'), getProperty('boyfriend.y')}
		stageData.opponent = {getProperty('dad.x'), getProperty('dad.y')}
		stageData.girlfriend = {getProperty('gf.x'), getProperty('gf.y')}

		if loadType == 'empty' or loadType == 'blank' then

			setPropertyFromClass('PlayState', 'SONG.stage', '*')

			if not (getPropertyFromClass('PlayState', 'curStage') == '*') then

				setProperty('camGame.alpha', 0)
				setProperty('camHUD.alpha', 0)
				setProperty('camOther.alpha', 0)

				wait(2) --maybe fixes some crashes?

				restartSong(false)

			end

		elseif not (loadType == 'stage') and not (fileName == '' or fileName == nil) then

			setPropertyFromClass('PlayState', 'SONG.stage', fileName)

			if not (getPropertyFromClass('PlayState', 'curStage') == fileName) then

				setProperty('camGame.alpha', 0)
				setProperty('camHUD.alpha', 0)
				setProperty('camOther.alpha', 0)

				wait(2)

				restartSong(false)

			end

		end
		
		
		--change filePath to the loaded mod images path
		if not (getPropertyFromClass('Paths', 'currentModDirectory') == '' or getPropertyFromClass('Paths', 'currentModDirectory') == nil) then
		
			if getCurrentStageFolder then
				filePath = 'mods/'..getPropertyFromClass('Paths', 'currentModDirectory')..'/stages'
			end
			
		else
		
			if getCurrentStageFolder then
				filePath = 'assets/stages'
			end
			
			setPropertyFromClass('Paths', 'currentModDirectory', '')
			
		end

	end

end

--it actually lags the game until its done lmao
function wait(seconds)
	local start = os.time()
	repeat until os.time() > start + seconds
end

--fixes a weird cursor movement
function onUpdatePost()

	if inEditor == true and getPropertyFromClass('PlayState', 'isStoryMode') == false then

		oldMouseX = math.floor(getMouseX(objProperties.camera))
		oldMouseY = math.floor(getMouseY(objProperties.camera))

		if versionToNumber(getPropertyFromClass("MainMenuState", "psychEngineVersion")) >= 61 then
		
			--adds the loaded objects
			--the second value is the object load limit
			for i = 1, 300 do

				if luaSpriteExists('obj'..i) then

					local contains = false

					for ii = 1, #objects do

						if objects[ii].obj == 'obj'..i then
							contains = true
						end

					end

					if contains == false then

						addObjectToEditor('obj'..(i))
						objects[#objects + 1] = {}

						--debugPrint('obj'..(i))

					end
					
					contains = false

				end

			end
		
		end

	end

end

function onUpdate()

	if inEditor == true then
	
		setProperty('camZooming', false)

		if useKeyboardControls == false then reloadCursorPos(true) end

		setObjectCamera('cursor', objProperties.camera)
		setObjectOrder('cursor', 99999)
		setScrollFactor('cursor', objProperties.scroll, objProperties.scroll)

		setProperty('objPreview.x', getProperty('cursor.x'))
		setProperty('objPreview.y', getProperty('cursor.y'))
		setScrollFactor('objPreview', objProperties.scroll, objProperties.scroll)
		scaleObject('objPreview', objProperties.scale, objProperties.scale)
		setObjectOrder('objPreview', objProperties.order)
		setObjectCamera('objPreview', objProperties.camera)
		if type == 0 or type == 1 then
			setProperty('objPreview.alpha', objProperties.alpha)
		end
		setProperty('objPreview.color', getColorFromHex('AAAAAA'))
		setProperty('objPreview.antialiasing', toboolean(objProperties.antialiasing))
		setProperty('objPreview.flipX', toboolean(objProperties.flipX))
		setProperty('objPreview.angle', objProperties.angle)

		setProperty('controlsBG.alpha', getProperty('controlsTxt.alpha') - 0.5)
		setProperty('propertiesBG.alpha', getProperty('propertiesTxt.alpha') - 0.5)


		--STAGE STUFF
		stageData.defaultZoom = getPropertyFromClass('flixel.FlxG', 'camera.zoom')

		setProperty('boyfriend.x', stageData.boyfriend[1])
		setProperty('boyfriend.y', stageData.boyfriend[2])
		setProperty('dad.x', stageData.opponent[1])
		setProperty('dad.y', stageData.opponent[2])
		setProperty('gf.x', stageData.girlfriend[1])
		setProperty('gf.y', stageData.girlfriend[2])

		local stageTxt = [[
		defaultZoom = ]]..stageData.defaultZoom..[[ 
		isPixelStage = ]]..stageData.isPixelStage..[[
		
		
		boyfriend = []]..stageData.boyfriend[1]..[[, ]]..stageData.boyfriend[2]..[[]
		girlfriend = []]..stageData.girlfriend[1]..[[, ]]..stageData.girlfriend[2]..[[]
		opponent = []]..stageData.opponent[1]..[[, ]]..stageData.opponent[2]..[[]
		]]

		setTextString('stageTxt', stageTxt)

		checkAnimatedProperty(objProperties.sprite)

		if type == 0 then
	
			if not (objProperties.anims == nil or objProperties.anims == {}) and curProperty == 'anim' then

				if objProperties.anim == 'all' then
					setTextString('propertiesTxt', '[Q]'..' < '..curProperty..': '..'[ALL ANIMS]'..' > '..'[E]')
				elseif #objProperties.anims > 0 then
					setTextString('propertiesTxt', '[Q]'..' < '..curProperty..': '..objProperties.anims[objProperties.anim]..' > '..'[E]')
				else
					setTextString('propertiesTxt', '[Q]'..' < '..curProperty..': '..objProperties[curProperty]..' > '..'[E]')
				end
				
			else
				setTextString('propertiesTxt', '[Q]'..' < '..curProperty..': '..objProperties[curProperty]..' > '..'[E]')
			end

			if objProperties.sprite == '' or objProperties.sprite == nil then
				setProperty('objPreview.visible', false)
			else
				setProperty('objPreview.visible', true)
			end


			local controlKeyStuff = {'A', 'D'}
			if useKeyboardControls then controlKeyStuff = {'Z', 'X'} end

			--CHANGE PROPERTY STUFF
			if curProperty == 'sprite' then
				setTextString('controlsTxt', 'CONTROLS: \nTAB - Save script \nENTER / Click - Place object \nALT + Click - Delete object \nSPACE - Type value \n(All controls are on Lua file)')
			elseif curProperty == 'antialiasing' or curProperty == 'camera' or curProperty == 'flipX' then	
				setTextString('controlsTxt', 'CONTROLS: \nTAB - Save script \nENTER / Click - Place object \nALT + Click - Delete object \nSPACE - Change value \n(All controls are on Lua file)')
			else
				setTextString('controlsTxt', 'CONTROLS: \nTAB - Save script \nENTER / Click - Place object \nALT + Click - Delete object \n'..controlKeyStuff[1]..' / '..controlKeyStuff[2]..' - Change value \n(All controls are on Lua file)')
			end

			if getProperty('objPreview.visible') == false then
				setProperty('propertiesTxt.color', getColorFromHex('606060'))
			end


			--ADD OBJECTS
			if (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') or mouseClicked()) and not (objProperties.sprite == '') then

				--change name of object based on how many objects there are so it doesn't overwrite other objects
				if objProperties.name == 'obj' then

					objName = 'obj'..(#objects)

					for i = 1, #objects-1 do

						if luaSpriteExists('obj'..(i)) == false then
							objName = 'obj'..(i)
							break
						end

					end

					if luaSpriteExists(objName) then
						objName = 'obj'..(#objects + 1)
					end

				--change the name of the object to the saved name (there is no saved name for now lol)
				else

					objName = objProperties.name

					if luaSpriteExists(objProperties.name) == true then

						debugPrint('An object with same name already exists.')

						for i = 1, #objects-1 do

							if luaSpriteExists('obj'..(i)) == false then
								objName = 'obj'..(i)
								break
							end

						end

						if luaSpriteExists(objName) then
							objName = 'obj'..(#objects + 1)
						end

					end

				end


				--add object
				if objProperties.animated == 'true' then
					makeAnimatedLuaSprite(objName, objProperties.sprite, getProperty('cursor.x'), getProperty('cursor.y'))
				else
					makeLuaSprite(objName, objProperties.sprite, getProperty('cursor.x'), getProperty('cursor.y'))
				end


				--set properties
				setObjectCamera(objName, objProperties.camera)
				setObjectOrder(objName, objProperties.order)
				scaleObject(objName, objProperties.scale, objProperties.scale)
				setScrollFactor(objName, objProperties.scroll, objProperties.scroll)
				setProperty(objName..'.alpha', objProperties.alpha)
				setProperty(objName..'.antialiasing', toboolean(objProperties.antialiasing))
				setProperty(objName..'.flipX', toboolean(objProperties.flipX))
				setProperty(objName..'.angle', objProperties.angle)
				addLuaSprite(objName, true)
				
				add = addObjectToEditor(objName)
				
				if not (add == 'error') then
					--next object
					objects[#objects + 1] = {}
				else
					debugPrint('An error occurred when adding the object')
					return
				end
				
			end


			--change properties
			if not (getPropertyFromClass('flixel.FlxG', 'mouse.wheel') == 0) then

				if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SPACE') and not (curProperty == 'camera') then
					changeProperty(curProperty, 'mouse')
				end

			end
			
			
			--change current property value
			local keys = {getPropertyFromClass('flixel.FlxG', 'keys.justPressed.A'), getPropertyFromClass('flixel.FlxG', 'keys.justPressed.D')}
			
			if useKeyboardControls then
				keys = {getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Z'), getPropertyFromClass('flixel.FlxG', 'keys.justPressed.X')}
			end
			
			if table.contains(keys, true) and not (curProperty == 'camera') then
				changeProperty(curProperty, 'key')
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then 

				if curProperty == 'antialiasing' then
					objProperties.antialiasing = tostring(not toboolean(objProperties.antialiasing))
					
				elseif curProperty == 'flipX' then
					objProperties.flipX = tostring(not toboolean(objProperties.flipX))

				elseif curProperty == 'camera' then
					changeProperty('camera', 'key')

				elseif curProperty == 'sprite' then
					type = 1
					--typedTxt = ''
					debugPrint('Typing..')
					setProperty('propertiesTxt.color', getColorFromHex('0096FF'))
				end

			end


			--change property
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Q') then

				curPropertyNum = curPropertyNum - 1
				if curPropertyNum < 1 then curPropertyNum = #options end

				if options[curPropertyNum] == 'anim' then
				
					if not (objProperties.animated == 'true') then
						curPropertyNum = curPropertyNum - 1
						if curPropertyNum < 1 then curPropertyNum = #options end
					end
					
				end
				
				curProperty = options[curPropertyNum]

			end

			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.E') then

				curPropertyNum = curPropertyNum + 1
				if curPropertyNum > #options then curPropertyNum = 1 end
				
				if options[curPropertyNum] == 'anim' then
				
					if not (objProperties.animated == 'true') then
						curPropertyNum = curPropertyNum + 1
						if curPropertyNum > #options then curPropertyNum = 1 end
					end
					
				end
				
				curProperty = options[curPropertyNum]

			end


			--other controls
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.TAB') then
				type = 2
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.ALT') or mousePressed('right') then
				type = 3
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SHIFT') then

				selectedObj = ''
				if useKeyboardControls == false then reloadCursorPos(false) end
				type = 4
				
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
				inEditor = false
				exitSong(false)
				if saveLastStage == true and not (fileName == '' or fileName == nil) then saveFileName() end
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then
				restartSong(false)
				if saveLastStage == true and not (fileName == '' or fileName == nil) then saveFileName() end
			end
			
			--undo
			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.CONTROL') then
			
				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Z') then
			
					if #undoObjectsList > 0 then

						local obj = undoObjectsList[#undoObjectsList]

						setProperty(obj..'.visible', true)
						setProperty(obj..'.active', true)

						undoObjectsList[#undoObjectsList] = nil
					
					end
				
				end

			end



		--CHANGE OBJECT SPRITE
		elseif type == 1 then

			curProperty = 'sprite'
			setTextString('propertiesTxt', '[Q]'..' < '..curProperty..': '..typedTxt..' > '..'[E]')


			--KEYS
			for i = 1, #allKeys do

				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..allKeys[i]) then

					--SPECIAL CHARACTERS
					if #allKeys[i] > 1 then

						if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') then
	
							if keyboardType:lower() == 'european' then

								if allKeys[i] == 'SEVEN' then
									typedTxt = typedTxt..'/'

								elseif allKeys[i] == 'EIGHT' then
									typedTxt = typedTxt..'('

								elseif allKeys[i] == 'NINE' then
									typedTxt = typedTxt..')'

								elseif allKeys[i] == 'MINUS' then
									typedTxt = typedTxt..'_'

								else
									typedTxt = typedTxt..specialChars[i]
								end

							else

								if allKeys[i] == 'NINE' then
									typedTxt = typedTxt..'('

								elseif allKeys[i] == 'ZERO' then
									typedTxt = typedTxt..')'

								elseif allKeys[i] == 'MINUS' then
									typedTxt = typedTxt..'_'

								else
									typedTxt = typedTxt..specialChars[i]
								end
								
							end

						else
							typedTxt = typedTxt..specialChars[i]
						end

					else

						if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') then
							typedTxt = typedTxt..allKeys[i]:upper()
						else
							typedTxt = typedTxt..allKeys[i]:lower()
						end

					end

				end

			end


			--DELETE TYPED STUFF
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
				typedTxt = typedTxt:sub(1, -2)
			end


			--EXIT
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') or mouseClicked('right') then
				type = 0
				typedTxt = objProperties.sprite
				debugPrint('Exiting Typing..')
				setProperty('propertiesTxt.color', getColorFromHex('FFFFFF'))
			end


			--EXIT AND LOAD
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then

				type = 0

				setProperty('objPreview.visible', false)
				setProperty('propertiesTxt.color', getColorFromHex('FFFFFF'))
				debugPrint('Exiting Typing and Loading Sprite..')


				if not (typedTxt == '' or typedTxt == nil) then

					local sprpath = ''

					if not (getPropertyFromClass('Paths', 'currentModDirectory') == '') then
					
						sprpath = 'mods/'..getPropertyFromClass('Paths', 'currentModDirectory')..'/images/'..typedTxt..'.png'

						if checkFileExists(sprpath, true) == false then
							sprpath = 'assets/shared/images/'..typedTxt..'.png'
						end
						
						if checkFileExists(sprpath, true) == false then
							sprpath = 'assets/images/'..typedTxt..'.png'
						end
						
						if checkFileExists(sprpath, true) == false then
							sprpath = 'mods/images/'..typedTxt..'.png'
						end
						
					else
					
						sprpath = 'assets/shared/images/'..typedTxt..'.png'
						
						if checkFileExists(sprpath, true) == false then
							sprpath = 'assets/images/'..typedTxt..'.png'
						end
						
						if checkFileExists(sprpath, true) == false then
							sprpath = 'mods/images/'..typedTxt..'.png'
						end
						
					end


					if checkFileExists(sprpath, true) == false then
						debugPrint('"'..sprpath..'"'.." sprite doesn't exist")
						typedTxt = objProperties.sprite
						return
					else
					
						setProperty('objPreview.visible', true)
						objProperties.sprite = typedTxt

						checkAnimatedProperty(objProperties.sprite)

						if objProperties.animated == 'true' then
							reloadPreviewSprite('anim')
						else
							reloadPreviewSprite('obj')
						end
						--loadGraphic('objPreview', objProperties.sprite)
						
					end

				end

			end


		--SAVING
		elseif type == 2 then

			setProperty('saveBG.visible', true)
			setProperty('saveTxt.visible', true)
			setProperty('savePathTxt.visible', true)
			setProperty('savePixelTxt.visible', true)
			
			if getCurrentStageFolder then
				setProperty('savePathTxt.alpha', 0.3)
			else
				setProperty('savePathTxt.alpha', 1)
			end
			
			setProperty('saveConfirmTxt.visible', true)

			setProperty('objPreview.visible', false)
			setProperty('cursor.visible', false)


			--KEYS
			for i = 1, #allKeys do

				if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..allKeys[i]) then

					--SPECIAL CHARACTERS
					if #allKeys[i] > 1 then

						if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') then
	
							if keyboardType:lower() == 'european' then

								if allKeys[i] == 'SEVEN' then
								
									if selected == 0 then
										fileName = fileName..'/'
									elseif selected == 1 then
										filePath = filePath..'/'
									end

								elseif allKeys[i] == 'EIGHT' then
								
									if selected == 0 then
										fileName = fileName..'('
									elseif selected == 1 then
										filePath = filePath..'('
									end

								elseif allKeys[i] == 'NINE' then
								
									if selected == 0 then
										fileName = fileName..')'
									elseif selected == 1 then
										filePath = filePath..')'
									end

								elseif allKeys[i] == 'MINUS' then
								
									if selected == 0 then
										fileName = fileName..'_'
									elseif selected == 1 then
										filePath = filePath..'_'
									end

								else
								
									if selected == 0 then
										fileName = fileName..specialChars[i]
									elseif selected == 1 then
										filePath = filePath..specialChars[i]
									end
									
								end

							else

								if allKeys[i] == 'NINE' then
								
									if selected == 0 then
										fileName = fileName..'('
									elseif selected == 1 then
										filePath = filePath..'('
									end

								elseif allKeys[i] == 'ZERO' then
								
									if selected == 0 then
										fileName = fileName..')'
									elseif selected == 1 then
										filePath = filePath..')'
									end

								elseif allKeys[i] == 'MINUS' then
								
									if selected == 0 then
										fileName = fileName..'_'
									elseif selected == 1 then
										filePath = filePath..'_'
									end

								else
								
									if selected == 0 then
										fileName = fileName..specialChars[i]
									elseif selected == 1 then
										filePath = filePath..specialChars[i]
									end
									
								end
								
							end

						else
						
							if selected == 0 then
								fileName = fileName..specialChars[i]
							elseif selected == 1 then
								filePath = filePath..specialChars[i]
							end
							
						end

					else

						if getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') then
						
							if selected == 0 then
								fileName = fileName..allKeys[i]:upper()
							elseif selected == 1 then
								filePath = filePath..allKeys[i]:upper()
							end
							
						else
						
							if selected == 0 then
								fileName = fileName..allKeys[i]:lower()
							elseif selected == 1 then
								filePath = filePath..allKeys[i]:lower()
							end
							
						end

					end
					
					setTextString('saveTxt', 'Script Name: '..fileName)
					setTextString('savePathTxt', 'Path: '..filePath)

				end

			end


			--DELETE TYPED STUFF
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
			
				if selected == 0 then
					fileName = fileName:sub(1, -2)
				elseif selected == 1 then
					filePath = filePath:sub(1, -2)
				end
				
				setTextString('saveTxt', 'Script Name: '..fileName)
				setTextString('savePathTxt', 'Path: '..filePath)
				
			end


			--EXIT
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
			
				setProperty('saveBG.visible', false)
				setProperty('saveTxt.visible', false)
				setProperty('savePathTxt.visible', false)
				setProperty('savePixelTxt.visible', false)
				
				setProperty('saveConfirmTxt.visible', false)

				setProperty('objPreview.visible', true)
				setProperty('cursor.visible', true)

				type = 0
				
			end


			--EXIT AND LOAD
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
			
				type = 0
				
				setProperty('saveBG.visible', false)
				setProperty('saveTxt.visible', false)
				setProperty('savePathTxt.visible', false)
				setProperty('savePixelTxt.visible', false)
				
				setProperty('saveConfirmTxt.visible', false)

				setProperty('objPreview.visible', true)
				setProperty('cursor.visible', true)

				saveStageFile(overwriteFile)
				
			end


			--CHANGE SELECTION
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DOWN') then
			
				if getCurrentStageFolder and selected == 0 then
					selected = 2
				else
					selected = selected + 1
				end
				
			end
			
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
			
				if getCurrentStageFolder and selected == 2 then
					selected = 0
				else
					selected = selected - 1
				end

			end
			
			if selected < 0 then
				selected = 0
			end
			if selected > 2 then
				selected = 2
			end
			
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DOWN') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
			
				setProperty('saveTxt.color', getColorFromHex('606060'))
				setProperty('savePathTxt.color', getColorFromHex('606060'))
				setProperty('savePixelTxt.color', getColorFromHex('606060'))

				if selected == 0 then
					setProperty('saveTxt.color', getColorFromHex('FFFFFF'))
				elseif selected == 1 then
					setProperty('savePathTxt.color', getColorFromHex('FFFFFF'))
				else
					setProperty('savePixelTxt.color', getColorFromHex('FFFFFF'))
				end
				
			end
			
			
			if selected == 2 and (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.LEFT') or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.RIGHT')) then
			
				if stageData.isPixelStage == 'false' then
					stageData.isPixelStage = 'true'
				else stageData.isPixelStage = 'false' end
				
				setTextString('savePixelTxt', '< Pixel Stage: '..stageData.isPixelStage..' >')
				
			end

		
		--DELETE OBJECTS
		elseif type == 3 then

			setProperty('objPreview.visible', false)
			setProperty('cursor.color', getColorFromHex('FF0000'))

			if mouseClicked() or getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then

				if #objects > 0 then
				
					local objs = {}

					--find objects that can be deleted
					for i = 1, #objects-1 do

						if not (objects[i] == nil or objects[i] == {}) then

							if objProperties.camera == objects[i].camera and getProperty(objects[i].obj..'.active') and objectCollision('cursor', objects[i].obj) then
								table.insert(objs, objects[i].obj)
								--removeLuaSprite(objects[i].obj, true)
								--table.remove(objects, i)
							end

						end

					end
					
					--sort objects that can be deleted based on what object order they have
					if #objs > 0 then
						
						table.sort(objs, function (a, b) return getObjectOrder(a) < getObjectOrder(b) end)

						local obj = objs[#objs]
						
						if not (obj == nil) then
						
							table.insert(undoObjectsList, obj)
							setProperty(obj..'.visible', false)
							setProperty(obj..'.active', false)
							
							debugPrint('Removed: ', obj)
							
						else
							debugPrint('Error when removing the object.')
							type = 0
							return
						end
						
					end

				end

			end

			--EXIT
			if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.ALT') or mouseReleased('right') then
				setProperty('objPreview.visible', true)
				setProperty('cursor.color', getColorFromHex('FFFFFF'))
				type = 0
			end


		--MOVE CHARACTERS/OBJECTS
		elseif type == 4 then

			setProperty('cursor.color', getColorFromHex('0096FF'))
			setProperty('objPreview.visible', false)
			
			if selectedObj == '' and mouseClicked() then
			
				if #objects > 0 then
				
					local objs = {}

					--find objects that can be selected
					for i = 1, #objects-1 do

						if not (objects[i] == nil or objects[i] == {}) then

							if objProperties.camera == objects[i].camera and getProperty(objects[i].obj..'.active') and objectCollision('cursor', objects[i].obj) then
								table.insert(objs, objects[i].obj)
							end

						end

					end
					
					--sort objects that can be selected based on what object order they have
					table.sort(objs, function (a, b) return getObjectOrder(a) < getObjectOrder(b) end)
					
					if objProperties.camera == 'camGame' then
					
						if objectCollision('cursor', 'gf') == true then
							selectedObj = 'gf'
						end

						if objectCollision('cursor', 'dad') == true then
							selectedObj = 'dad'
						end

						if objectCollision('cursor', 'boyfriend') == true then
							selectedObj = 'boyfriend'
						end
						
					end

					if #objs > 0 then
					
						if (not (selectedObj == '') and getObjectOrder(objs[#objs]) > getObjectOrder(selectedObj..'Group')) or selectedObj == '' then
						
							if not (objs[#objs] == nil) then
								selectedObj = objs[#objs]
							else
								debugPrint('Error when selecting the object.')
								type = 0
								return
							end
							
						end

					end
					
				end

			end
			
			if mouseReleased() then
				selectedObj = ''
			end

			if not (selectedObj == '') then

				if selectedObj == 'dad' then
					stageData['opponent'][1] = math.floor(getProperty('cursor.x') - getProperty('dad._frame.frame.width') * 0.5)
					stageData['opponent'][2] = math.floor(getProperty('cursor.y') - getProperty('dad._frame.frame.height') * 0.5)

				elseif selectedObj == 'gf' then
					stageData['girlfriend'][1] = math.floor(getProperty('cursor.x') - getProperty('gf._frame.frame.width') * 0.5)
					stageData['girlfriend'][2] = math.floor(getProperty('cursor.y') - getProperty('gf._frame.frame.height') * 0.5)

				elseif selectedObj == 'boyfriend' then
					stageData['boyfriend'][1] = math.floor(getProperty('cursor.x') - getProperty('boyfriend._frame.frame.width') * 0.5)
					stageData['boyfriend'][2] = math.floor(getProperty('cursor.y') - getProperty('boyfriend._frame.frame.height') * 0.5)
				else
					setProperty(selectedObj..'.x', math.floor(getProperty('cursor.x') - getProperty('boyfriend._frame.frame.width') * 0.5))
					setProperty(selectedObj..'.y', math.floor(getProperty('cursor.y') - getProperty('boyfriend._frame.frame.height') * 0.5))
					
					objects[findObject(selectedObj)].x = getProperty(selectedObj..'.x')
					objects[findObject(selectedObj)].y = getProperty(selectedObj..'.y')
				end

			end

			--EXIT
			if getPropertyFromClass('flixel.FlxG', 'keys.justReleased.SHIFT') then
			
				setProperty('objPreview.visible', true)
				setProperty('cursor.color', getColorFromHex('FFFFFF'))

				if useKeyboardControls == false then reloadCursorPos(false) end

				selectedObj = ''
				type = 0
				
			end

		end

		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.NINE') and type == 0 then

			setPropertyFromClass('PlayState', 'seenCutscene', false)
			inEditor = false

			setPropertyFromClass('PlayState', 'SONG.stage', fileName)

			restartSong(false)

			if saveLastStage == true and not (fileName == '' or fileName == nil) then saveFileName() end

		end

		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DELETE') then

			--loadStageFile(filePath..fileName)

			if getProperty('propertiesTxt.alpha') == 0 then
				setProperty('propertiesTxt.alpha', 1)
				setProperty('objPreview.alpha', 1)
				--setProperty('cursor.alpha', 1)
				setProperty('controlsTxt.alpha', 1)
				setProperty('stageTxt.alpha', 1)
			else
				setProperty('propertiesTxt.alpha', 0)
				setProperty('objPreview.alpha', 0)
				--setProperty('cursor.alpha', 0)
				setProperty('controlsTxt.alpha', 0)
				setProperty('stageTxt.alpha', 0)
			end

		end


		if type == 0 or type == 3 or type == 4 then

			--MOVE MOUSE WITH KEYS
			if useKeyboardControls == true then
			
				if getPropertyFromClass('flixel.FlxG', 'keys.pressed.A') then
					setProperty('cursor.x', getProperty('cursor.x') - 10)
				end

				if getPropertyFromClass('flixel.FlxG', 'keys.pressed.D') then
					setProperty('cursor.x', getProperty('cursor.x') + 10)
				end

				if getPropertyFromClass('flixel.FlxG', 'keys.pressed.W') then
					setProperty('cursor.y', getProperty('cursor.y') - 10)
				end

				if getPropertyFromClass('flixel.FlxG', 'keys.pressed.S') then
					setProperty('cursor.y', getProperty('cursor.y') + 10)
				end

			end

		

			--CAMERA STUFF
			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.LEFT') then
				camVarXL = -10
			elseif getPropertyFromClass('flixel.FlxG', 'keys.released.LEFT') then
				camVarXL = 0
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.RIGHT') then
				camVarXR = 10
			elseif getPropertyFromClass('flixel.FlxG', 'keys.released.RIGHT') then
				camVarXR = 0
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.UP') then
				camVarYU = -10
			elseif getPropertyFromClass('flixel.FlxG', 'keys.released.UP') then
				camVarYU = 0
			end

			if getPropertyFromClass('flixel.FlxG', 'keys.pressed.DOWN') then
				camVarYD = 10
			elseif getPropertyFromClass('flixel.FlxG', 'keys.released.DOWN') then
				camVarYD = 0
			end

			setProperty('camFollow.x', getProperty('camFollow.x') + (camVarXR + camVarXL))
			setProperty('camFollow.y', getProperty('camFollow.y') + (camVarYD + camVarYU))


			--CHANGE CAMERA ZOOM
			if not (getPropertyFromClass('flixel.FlxG', 'mouse.wheel') == 0) then

				if not (getPropertyFromClass('flixel.FlxG', 'keys.pressed.SPACE')) then
				
					setPropertyFromClass('flixel.FlxG', 'camera.zoom', getPropertyFromClass('flixel.FlxG', 'camera.zoom') + (getPropertyFromClass('flixel.FlxG', 'mouse.wheel') / 20))
					
					--limit the camera so it doesn't lag the game on crazy zooms
					if getPropertyFromClass('flixel.FlxG', 'camera.zoom') > 5 then
						setPropertyFromClass('flixel.FlxG', 'camera.zoom', 5)
					end
					
					if getPropertyFromClass('flixel.FlxG', 'camera.zoom') < 0.1 then
						setPropertyFromClass('flixel.FlxG', 'camera.zoom', 0.1)
					end
					
				end

			end

		end

	else	

		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.NINE') then
			setPropertyFromClass('PlayState', 'seenCutscene', true)
			inEditor = true
			restartSong(false)
		end

	end

end

function changeProperty(property, type)

	local keys = {getPropertyFromClass('flixel.FlxG', 'keys.justPressed.A'), getPropertyFromClass('flixel.FlxG', 'keys.justPressed.D')}
			
	if useKeyboardControls then
		keys = {not (getPropertyFromClass('flixel.FlxG', 'keys.pressed.CONTROL')) and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.Z'), getPropertyFromClass('flixel.FlxG', 'keys.justPressed.X')}
	end

	if property == 'order' then

		if type == 'mouse' then
			objProperties.order = objProperties.order + getPropertyFromClass('flixel.FlxG', 'mouse.wheel')
		else

			if keys[2] then
				objProperties.order = objProperties.order + 1
			end

			if keys[1] then
				objProperties.order = objProperties.order - 1
			end

		end

		if objProperties.order < 0.1 then
			objProperties.order = 0
		end
		
		return
		
	elseif property == 'anim' and objProperties.animated == 'true' and #objProperties.anims > 1 then
	
		if type == 'mouse' then
		
			local val = getPropertyFromClass('flixel.FlxG', 'mouse.wheel')
			
			if objProperties.anim == 'all' then
			
				if val < 0 then
					objProperties.anim = #objProperties.anims
				else
					objProperties.anim = 1
				end
				
			else
				objProperties.anim = objProperties.anim + val
			end
			
		else

			if keys[2] then
			
				if objProperties.anim == 'all' then
					objProperties.anim = 1
				else
					objProperties.anim = objProperties.anim + 1
				end
				
			end

			if keys[1] then
			
				if objProperties.anim == 'all' then
					objProperties.anim = #objProperties.anims
				else
					objProperties.anim = objProperties.anim - 1
				end
				
			end

		end
		
		if not (objProperties.anim == 'all') then

			if objProperties.anim < 1 and #objProperties.anims > 1 then
				objProperties.anim = 'all'
				objectPlayAnimation('objPreview', 'anim1', true)
			end
			
			if #objProperties.anims > 0 then
			
				if objProperties.anim > #objProperties.anims then
				
					if #objProperties.anims > 1 then
						objProperties.anim = 'all'
						objectPlayAnimation('objPreview', 'anim1', true)
					else
						objProperties.anim = #objProperties.anims
						objectPlayAnimation('objPreview', 'anim'..objProperties.anim, true)
					end
					
				else
					objectPlayAnimation('objPreview', 'anim'..objProperties.anim, true)
				end
				
			end
		
		end
		
		return
		
	elseif property == 'angle' then

		if type == 'mouse' then
			objProperties.angle = objProperties.angle + getPropertyFromClass('flixel.FlxG', 'mouse.wheel') * 5
		else

			if keys[2] then
				objProperties.angle = objProperties.angle + 5
			end

			if keys[1] then
				objProperties.angle = objProperties.angle - 5
			end

		end

		if objProperties.angle < 0 then
			objProperties.angle = 355
		end
		
		if objProperties.angle < 0.1 then
			objProperties.angle = 0
		end
		
		if objProperties.angle > 355 then
			objProperties.angle = 0
		end
		
		return
		
	elseif property == 'camera' then

		if objProperties.camera == 'camGame' then objProperties.camera = 'camHUD' reloadCursorPos(false) return end
		if objProperties.camera == 'camHUD' then objProperties.camera = 'camOther' reloadCursorPos(false) return end
		if objProperties.camera == 'camOther' then objProperties.camera = 'camGame' reloadCursorPos(false) return end

	elseif property == 'scale' then

		if type == 'mouse' then
			objProperties.scale = objProperties.scale + getPropertyFromClass('flixel.FlxG', 'mouse.wheel') / 10
		else

			if keys[2] then
				objProperties.scale = objProperties.scale + 0.1
			end

			if keys[1] then
				objProperties.scale = objProperties.scale - 0.1
			end

		end

		if objProperties.scale < 0.1 then
			objProperties.scale = 0
		end
		
		return

	elseif property == 'scroll' then

		if type == 'mouse' then
			objProperties.scroll = objProperties.scroll + getPropertyFromClass('flixel.FlxG', 'mouse.wheel') / 10
			if useKeyboardControls == false then reloadCursorPos(false) end
		else

			if keys[2] then
				objProperties.scroll = objProperties.scroll + 0.1
			end

			if keys[1] then
				objProperties.scroll = objProperties.scroll - 0.1
			end
			if useKeyboardControls == false then reloadCursorPos(false) end

		end

		if objProperties.scroll < 0.1 then
			objProperties.scroll = 0
		end
		
		return

	elseif property == 'alpha' then

		if type == 'mouse' then
			objProperties.alpha = objProperties.alpha + getPropertyFromClass('flixel.FlxG', 'mouse.wheel') / 10
		else

			if keys[2] then
				objProperties.alpha = objProperties.alpha + 0.1
			end

			if keys[1] then
				objProperties.alpha = objProperties.alpha - 0.1
			end

		end

		if objProperties.alpha > 1 then
			objProperties.alpha = 1
		end
		
		if objProperties.alpha < 0.1 then
			objProperties.alpha = 0
		end
		
		return

	end
	
end

function saveStageFile(overwrite)

	local rawcontent = [[
--created with Super_Hugo's Stage Editor v1.6.3

function onCreate()

]]

	if #objects > 1 then

		for i = 1, #objects-1 do

			if not (objects[i] == nil or objects[i] == {}) and getProperty(objects[i].obj..'.active') then

				if (objects[i].anims == nil or objects[i].anims == '') then

	rawcontent = rawcontent..[[
	makeLuaSprite(']]..(objects[i].obj)..[[', ']]..(objects[i].sprite)..[[', ]]..(getProperty(objects[i].obj..'.x'))..[[, ]]..(getProperty(objects[i].obj..'.y'))..[[)
]]

				else

	rawcontent = rawcontent..[[
	makeAnimatedLuaSprite(']]..(objects[i].obj)..[[', ']]..(objects[i].sprite)..[[', ]]..(getProperty(objects[i].obj..'.x'))..[[, ]]..(getProperty(objects[i].obj..'.y'))..[[)
]]
				end
				
				if not (objects[i].camera == 'camGame') then

	rawcontent = rawcontent..[[
	setObjectCamera(']]..(objects[i].obj)..[[', ']]..(objects[i].camera)..[[')
]]

				end

	rawcontent = rawcontent..[[
	setObjectOrder(']]..(objects[i].obj)..[[', ]]..objects[i].order..[[)
]]

				if not (objects[i].scale == 1) then

	rawcontent = rawcontent..[[
	scaleObject(']]..(objects[i].obj)..[[', ]]..(objects[i].scale)..[[, ]]..(objects[i].scale)..[[)
]]

				end

				if not (objects[i].scroll == 1) then

	rawcontent = rawcontent..[[
	setScrollFactor(']]..(objects[i].obj)..[[', ]]..(objects[i].scroll)..[[, ]]..(objects[i].scroll)..[[)
]]

				end

				if not (objects[i].alpha == 1) then

	rawcontent = rawcontent..[[
	setProperty(']]..(objects[i].obj)..[[.alpha', ]]..(objects[i].alpha)..[[)
]]

				end
				
				if not (objects[i].angle == 0) then

	rawcontent = rawcontent..[[
	setProperty(']]..(objects[i].obj)..[[.angle', ]]..(objects[i].angle)..[[)
]]

				end

				if not (objects[i].antialiasing == 'true') then

	rawcontent = rawcontent..[[
	setProperty(']]..(objects[i].obj)..[[.antialiasing', ]]..(objects[i].antialiasing)..[[)
]]

				end
				
				if not (objects[i].flipX == 'false') then

	rawcontent = rawcontent..[[
	setProperty(']]..(objects[i].obj)..[[.flipX', ]]..(objects[i].flipX)..[[)
]]

				end

				if not (objects[i].anims == nil) then
				
					if tostring(objects[i].anim):lower() == 'all' then

	rawcontent = rawcontent..[[

]]

						for ii = 1, #objects[i].anims do

	rawcontent = rawcontent..[[
	addAnimationByPrefix(']]..(objects[i].obj)..[[', 'anim]]..ii..[[', ']]..(objects[i].anims[ii])..[[', 24, true)
]]

						end

	rawcontent = rawcontent..[[

	playAnim(']]..(objects[i].obj)..[[', 'anim1', true)
]]

					elseif not (objects[i].anim == nil) then
					
	rawcontent = rawcontent..[[
	addAnimationByPrefix(']]..(objects[i].obj)..[[', 'anim', ']]..(objects[i].anims[objects[i].anim])..[[', 24, true)
]]

	rawcontent = rawcontent..[[
	playAnim(']]..(objects[i].obj)..[[', 'anim', true)
]]

					end

				end

	rawcontent = rawcontent..[[
	addLuaSprite(']]..(objects[i].obj)..[[', true)
	
]]

			end

		end

	end

	rawcontent = rawcontent..'end'

	rawcontent2 = [[
{
	"directory": "]]..stageData.directory..[[",
	"defaultZoom": ]]..stageData.defaultZoom..[[,
	"isPixelStage": ]]..stageData.isPixelStage..[[,

	"boyfriend": []]..(stageData.boyfriend[1] - getProperty('boyfriend.positionArray')[1])..[[, ]]..(stageData.boyfriend[2] - getProperty('boyfriend.positionArray')[2])..[[],
	"girlfriend": []]..(stageData.girlfriend[1] - getProperty('gf.positionArray')[1])..[[, ]]..(stageData.girlfriend[2] - getProperty('gf.positionArray')[2])..[[],
	"opponent": []]..(stageData.opponent[1] - getProperty('dad.positionArray')[1])..[[, ]]..(stageData.opponent[2] - getProperty('dad.positionArray')[2])..[[],
	"hide_girlfriend": ]]..stageData.hide_girlfriend..[[

}]]

	debugPrint('')

	if #objects > 1 then
	
		if overwrite == true then

			if checkFileExists(filePath..'/'..fileName..'.lua', true) == true then
				deleteFile(filePath..'/'..fileName..'.lua', true)
				debugPrint('- Overwrote file with same name: ', fileName..'.lua')
			end

			saveFile(filePath..'/'..fileName..'.lua', rawcontent, true)
		
			if checkFileExists(filePath..'/'..fileName..'.lua', true) == true then
				debugPrint('Lua file saved in: ', filePath..'/'..fileName..'.lua')
			else
				saveFile('assets/stages/'..fileName..'.lua', rawcontent, true)
				debugPrint('Lua saved in another folder due to an error: ', 'assets/stages/'..fileName..'.lua')
			end

		elseif overwrite == false then

			if checkFileExists(filePath..'/'..fileName..'.lua', true) == true then
				debugPrint('There is already a file with same name in: ', filePath..'/'..fileName..'.lua')
				return
			
			else
		
				saveFile(filePath..'/'..fileName..'.lua', rawcontent, true)
			
				if checkFileExists(filePath..'/'..fileName..'.lua', true) == true then
					debugPrint('Lua file saved in: ', filePath..'/'..fileName..'.lua')
				else
					saveFile('assets/stages/'..fileName..'.lua', rawcontent, true)
					debugPrint('Lua saved in another folder due to an error: ', 'assets/stages/'..fileName..'.lua')
				end
			
			end
	
		else
			debugPrint('Error saving lua file: ', 'Error when saving')
			return
		end
		
	else
		debugPrint("Lua file couldn't be saved: " , 'No objects found')
		return
	end


	debugPrint('')

	if overwrite == true then

		if checkFileExists(filePath..'/'..fileName..'.json', true) == true then
			deleteFile(filePath..'/'..fileName..'.json', true)
			debugPrint('- Overwrote file with same name: ', fileName..'.json')
		end

		saveFile(filePath..'/'..fileName..'.json', rawcontent2, true)
		
		if checkFileExists(filePath..'/'..fileName..'.json', true) == true then
			debugPrint('Stage file saved in: ', filePath..'/'..fileName..'.json')
		else
			saveFile('assets/stages/'..fileName..'.json', rawcontent2, true)
			debugPrint('Stage saved in another folder due to an error: ', 'assets/stages/'..fileName..'.json')
		end

	elseif overwrite == false then

		if checkFileExists(filePath..'/'..fileName..'.json', true) == true then
			debugPrint('There is already a file with same name in: ', filePath..'/'..fileName..'.json')
			return
			
		else
		
			saveFile(filePath..'/'..fileName..'.json', rawcontent2, true)
			
			if checkFileExists(filePath..'/'..fileName..'.json', true) == true then
				debugPrint('Stage file saved in: ', filePath..'/'..fileName..'.json')
			else
				saveFile('assets/stages/'..fileName..'.json', rawcontent2, true)
				debugPrint('Stage saved in another folder due to an error: ', 'assets/stages/'..fileName..'.json')
			end
			
		end
	
	else
		debugPrint('Error saving stage file: ', 'Error when saving')
		return
	end

	
	--save changes to this lua file for later loading the saved stage
	if saveLastStage == true and not (fileName == '' or fileName == nil) then saveFileName() end

end

function saveFileName()

	--save fileName
	local _, z = string.find(scriptName, 'assets/')

	local scriptText = getTextFromFile(string.sub(scriptName, z + 1), true)

	local _, m = string.find(scriptText, "fileName = '")

	local l = string.sub(scriptText, m + 1)

	local s = string.find(l, "'")

	local stageName = string.sub(l, 0, s - 1)

	scriptText = string.sub(scriptText, 0, m)..fileName..string.sub(scriptText, s + m)
	
	
	--save filePath
	local _, m = string.find(scriptText, "filePath = '")

	local l = string.sub(scriptText, m + 1)

	local s = string.find(l, "'")

	scriptText = string.sub(scriptText, 0, m)..filePath..string.sub(scriptText, s + m)

	saveFile(scriptName, scriptText, true)

end

function reloadPreviewSprite(type)

	if type == 'anim' then

		removeLuaSprite('objPreview', true)

		makeAnimatedLuaSprite('objPreview', objProperties.sprite, getMouseX(objProperties.camera), getMouseY(objProperties.camera))
		setObjectCamera('objPreview', objProperties.camera)
		addLuaSprite('objPreview', true)
		
		objProperties.anims = nil
		objProperties.anim = 1
		
		local path = checkXmlFile(objProperties.sprite)
		
		if not (path == nil) then
			objProperties.anims = getAnimationsFromXml(path)
		end
		
		if #objProperties.anims > 0 then

			for i = 1, #objProperties.anims do

				if not (objProperties.anims[i] == nil) then
					addAnimationByPrefix('objPreview', 'anim'..i, objProperties.anims[i], 24, true)
				end

			end
			
			objectPlayAnimation('objPreview', 'anim1', true)
		
		else
			debugPrint('Error loading animations for preview.')
			objProperties.animated = 'false'
		end

	else

		removeLuaSprite('objPreview', true)

		makeLuaSprite('objPreview', objProperties.sprite, getMouseX(objProperties.camera), getMouseY(objProperties.camera))
		setObjectCamera('objPreview', objProperties.camera)
		addLuaSprite('objPreview', true)

	end

end

function reloadCursorPos(whenMoving)

	--fixes cursor issues with game camera
	if objProperties.camera == 'camGame' then

		if not (math.floor(getMouseX(objProperties.camera)) == oldMouseX) or whenMoving == false then
			setProperty('cursor.x', math.floor(getMouseX('camGame') + (getProperty('camFollowPos.x') - 650) * objProperties.scroll)) --getMouseX(objProperties.camera)
		end
		if not (math.floor(getMouseY(objProperties.camera)) == oldMouseY) or whenMoving == false then
			setProperty('cursor.y', math.floor(getMouseY('camGame') + (getProperty('camFollowPos.y') - 350) * objProperties.scroll))
		end

	else

		if not (math.floor(getMouseX(objProperties.camera)) == oldMouseX) or whenMoving == false then
			setProperty('cursor.x', math.floor(getMouseX(objProperties.camera)))
		end
		if not (math.floor(getMouseY(objProperties.camera)) == oldMouseY) or whenMoving == false then
			setProperty('cursor.y', math.floor(getMouseY(objProperties.camera)))
		end

	end

end

function addObjectToEditor(object)

	if versionToNumber(getPropertyFromClass("MainMenuState", "psychEngineVersion")) >= 61 then
	
		--prepare some values
		runHaxeCode([[
			function cameraToString(camera) {
				switch(camera) {
					case PlayState.instance.camHUD: return 'camHUD';
					case PlayState.instance.camOther: return 'camOther';
				}
				return 'camGame';
			}

			var obj = PlayState.instance.getLuaObject(']]..object..[[');
			
			game.setOnLuas(']]..object..[[.scrollX', obj.scrollFactor.x);
			game.setOnLuas(']]..object..[[.daCamera', cameraToString(obj.cameras[0]));
		]])
		
		local imageName = getProperty(object..'.graphic.key')
		imageName = string.gsub(imageName, ".png", "")
		imageName = string.sub(imageName, string.find(imageName, 'images/'), -1)
		imageName = string.gsub(imageName, "images/", "")
		
		if imageName == 'logo/default' then
			
			if not (getPropertyFromClass('Paths', 'currentModDirectory') == '') then
				debugPrint('Check if the image is in "mods/'..getPropertyFromClass('Paths', 'currentModDirectory')..'/images" or "mods/images"')
				debugPrint('['..object..'] - ', 'Error loading sprite.')
			else
				debugPrint('Check if the image is in "mods/images"')
				debugPrint('['..object..'] - ', 'Error loading sprite.')
			end
			
			_G[object..'.daCamera'] = nil
			_G[object..'.scrollX'] = nil
			
			removeLuaSprite(object, true)
			
			objects[#objects] = nil
			objProperties.animated = 'false'
			
			objProperties.sprite = 'combo'
			reloadPreviewSprite('obj')
			
			return 'error'
			
		end
		

		--save properties of the object
		objects[#objects].obj = object
		objects[#objects].x = getProperty(object..'.x')
		objects[#objects].y = getProperty(object..'.y')
		objects[#objects].sprite = imageName
		objects[#objects].order = getObjectOrder(object)
		objects[#objects].camera = _G[object..'.daCamera']
		objects[#objects].scale = getProperty(object..'.scale.x')
		objects[#objects].alpha = getProperty(object..'.alpha')
		objects[#objects].scroll = _G[object..'.scrollX']
		objects[#objects].angle = getProperty(object..'.angle')
		objects[#objects].flipX = tostring(getProperty(object..'.flipX'))
		objects[#objects].antialiasing = tostring(getProperty(object..'.antialiasing'))
		objects[#objects].anims = nil
		
		
		--animated objects
		checkAnimatedProperty(objects[#objects].sprite)
		
		if objProperties.animated == 'true' then
		
			local alreadyHasAnims = false
			if not (getProperty(object..'.animation.curAnim.name') == nil or getProperty(object..'.animation.curAnim.name') == object..'.animation.curAnim.name') then alreadyHasAnims = true end

			local path = checkXmlFile(objects[#objects].sprite)

			if not (path == nil) then
				objects[#objects].anims = getAnimationsFromXml(path)
			end

			if #objects[#objects].anims > 0 then
			
				for i = 1, #objects[#objects].anims do

					if not (objects[#objects].anims[i] == nil) then
						addAnimationByPrefix(objName, 'anim'..i, objects[#objects].anims[i], 24, true)
					end

				end

				if alreadyHasAnims then
			
					for i = 1, #objects[#objects].anims do

						--i need to check this a bit more, because i don't think this will work
						if objects[#objects].anims[i]..'000' == getProperty(object..'.animation.frameName') then
							objects[#objects].anim = i
						end
						
					end

				else
					objects[#objects].anim = objProperties.anim
					objectPlayAnimation(objName, 'anim'..objects[#objects].anim, true)
				end
			
			else
				debugPrint('Error loading animations for sprite "'..imageName..'".')
			end

		end
		
		objProperties.animated = 'false'
		_G[object..'.daCamera'] = nil
		_G[object..'.scrollX'] = nil
		
		return
	
	else
	
		local imageName = getProperty(object..'.graphic.key')
		imageName = string.gsub(imageName, ".png", "")
		imageName = string.sub(imageName, string.find(imageName, 'images/'), -1)
		imageName = string.gsub(imageName, "images/", "")
		
		if imageName == 'logo/default' then
			
			if not (getPropertyFromClass('Paths', 'currentModDirectory') == '') then
				debugPrint('Check if the image is in "mods/'..getPropertyFromClass('Paths', 'currentModDirectory')..'/images" or "mods/images"')
				debugPrint('['..object..'] - ', 'Error loading sprite.')
			else
				debugPrint('Check if the image is in "mods/images"')
				debugPrint('['..object..'] - ', 'Error loading sprite.')
			end
			
			removeLuaSprite(object, true)
			
			objects[#objects] = nil
			
			objProperties.sprite = 'combo'
			reloadPreviewSprite('obj')
			
			return 'error'
			
		end
	
		--save properties of the object
		objects[#objects].obj = object
		objects[#objects].x = getProperty(object..'.x')
		objects[#objects].y = getProperty(object..'.y')
		objects[#objects].sprite = imageName
		objects[#objects].order = getObjectOrder(object)
		objects[#objects].camera = objProperties.camera
		objects[#objects].scale = getProperty(object..'.scale.x')
		objects[#objects].alpha = getProperty(object..'.alpha')
		objects[#objects].scroll = objProperties.scroll
		objects[#objects].flipX = tostring(getProperty(object..'.flipX'))
		objects[#objects].antialiasing = tostring(getProperty(object..'.antialiasing'))
		
		objects[#objects].anims = nil
		
		--animated objects
		checkAnimatedProperty(objects[#objects].sprite)
		
		if objProperties.animated == 'true' then

			local alreadyHasAnims = false
			if not (getProperty(object..'.animation.curAnim.name') == nil or getProperty(object..'.animation.curAnim.name') == object..'.animation.curAnim.name') then alreadyHasAnims = true end
			
			local path = checkXmlFile(objects[#objects].sprite)

			if not (path == nil) then
				objects[#objects].anims = getAnimationsFromXml(path)
			end
			
			if #objects[#objects].anims > 0 then
			
				for i = 1, #objects[#objects].anims do

					if not (objects[#objects].anims[i] == nil) then
						addAnimationByPrefix(objName, 'anim'..i, objects[#objects].anims[i], 24, true)
					end

				end

				if alreadyHasAnims then
			
					for i = 1, #objects[#objects].anims do
					
						if objects[#objects].anims[i]..'000' == getProperty(object..'.animation.frameName') then
							objects[#objects].anim = i
						end
						
					end

				else
					objects[#objects].anim = objProperties.anim
					objectPlayAnimation(objName, 'anim'..objects[#objects].anim, true)
				end
			
			else
				debugPrint('Error loading animations for sprite "'..imageName..'".')
			end

		end
		
		objProperties.animated = 'false'
		
		return
		
	end

end

function findObject(obj)
	
	for i, _ in ipairs(objects) do
	
		if objects[i].obj == obj then
			return i
		end
		
	end
	
	return nil
	
end

--converts the game version to numbers (example: 0.6.1 to 61)
function versionToNumber(ver)

	local str = ''
	
	string.gsub(ver, '%d+', function(a) str = str..a end)
	return tonumber(str)
	
end

function checkAnimatedProperty(sprite)

	--CHECK IF THE FILE SHOULD BE ANIMATED
	if not (getPropertyFromClass('Paths', 'currentModDirectory') == '') then

		if checkFileExists('mods/'..getPropertyFromClass('Paths', 'currentModDirectory')..'/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		elseif checkFileExists('assets/shared/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		elseif checkFileExists('assets/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		elseif checkFileExists('mods/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
		
		else
			objProperties.animated = 'false'
		end

	else

		if checkFileExists('assets/shared/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		elseif checkFileExists('assets/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		elseif checkFileExists('mods/images/'..sprite..'.xml', true) == true then
			objProperties.animated = 'true'
			
		else
			objProperties.animated = 'false'
		end

	end

end

function checkXmlFile(sprite)

	local exists = false
	
	if checkFileExists('images/'..sprite..'.xml', false) then
		exists = true
	elseif checkFileExists('assets/images/'..sprite..'.xml', true) then
		exists = true
	elseif checkFileExists('mods/images/'..sprite..'.xml', true) then
		exists = true
	elseif checkFileExists('assets/shared/images/'..sprite..'.xml', true) then
		exists = true
	end

	--all of that just for this lmao
	if exists then
		return 'images/'..sprite..'.xml'
	end
	
	return nil
		
end

function getAnimationsFromXml(xml)

	xmlText = getTextFromFile(xml, false)

	if not (xmlText == nil or xmlText == '') then

		xmlAnims = {}

		for char in string.gmatch(xmlText, '"(.-)"') do
		
			if tonumber(char) == nil and not (string.find(char, '.png')) and not (string.find(char, 'utf')) then
			
				--debugPrint(char)
				
				if string.find(char, '00') then
				
					local anim = string.sub(char, 0, string.find(char, '0'))

					if not (table.contains(xmlAnims, anim)) then
						xmlAnims[#xmlAnims + 1] = anim
					end
					
				else
					xmlAnims[#xmlAnims + 1] = char
				end
				
			end 

		end
		
		--debugPrint(xmlAnims)
		
		if not (xmlAnims == nil) then
			return xmlAnims
		end
	
	end
	
	return nil

end

function toboolean(string)

    local bool = false

    if string == 'true' then
        bool = true
    end

    return bool

end

function table.contains(table, val)

	for i = 1, #table do

		if table[i] == val then
			return true
		end

	end
	return false

end

--thanks to this function it fixes the weird boundary thing, nice
function objectCollision(obj1, obj2)

	return getProperty(obj1..'.x') < getProperty(obj2..'.x') + getProperty(obj2..'.width') and
		getProperty(obj2..'.x') < getProperty(obj1..'.x') + getProperty(obj1..'.width') and
		getProperty(obj1..'.y') < getProperty(obj2..'.y') + getProperty(obj2..'.height') and
		getProperty(obj2..'.y') < getProperty(obj1..'.y') + getProperty(obj1..'.height')

end

function onDestroy()

	if getPropertyFromClass('PlayState', 'seenCutscene') == true and inEditor == false then
		setPropertyFromClass('PlayState', 'seenCutscene', false)
	end

end

function onStartCountdown()

	if getPropertyFromClass('PlayState', 'seenCutscene') == true and getPropertyFromClass('PlayState', 'isStoryMode') == false then
		return Function_Stop;
	end
	return Function_Continue;

end
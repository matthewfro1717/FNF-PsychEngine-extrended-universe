--add your 3d char here
floaters = {'dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d'}
exclude = {'figumbi'} --only apply the 3d notes
shitters = {}
elapsedTime = 0
function onCreate()
  luaDebugMode = true
end
function onCreatePost()
  if songName:lower() ~= dofile('mods/'..currentModDirectory..'/modName.lua') then
    shitters = {
      {dadName, 'dad', false, getProperty('dad.cameraPosition')},
      {boyfriendName, 'boyfriend', true, getProperty('boyfriend.cameraPosition')},
      {gfName, 'gf', nil, getProperty('gf.cameraPosition')}
    }
    for k,v in pairs(floaters) do
      for i=1,2 do
        if (i == 1 and dadName or boyfriendName) == v then
          for o=1,4 do
            setPropertyFromGroup('strumLineNotes', (o*i)-1, 'texture', 'notes/NOTE_assets_3D')
            setPropertyFromGroup('strumLineNotes', (o*i)-1, 'antialiasing', false)
          end
          for i = 0, getProperty('unspawnNotes.length')-1 do
            if getPropertyFromGroup('unspawnNotes', i, 'noteType') == '' or getPropertyFromGroup('unspawnNotes', i, 'noteType') == nil then
              if not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
                if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == (i == 2) or getPropertyFromGroup('unspawnNotes', i, 'mustPress') ~= (i == 2) and getRandomBool(25) then
                  setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_assets_3D')
                  setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false)
                  checkSus(i+1)
                end
              end
            end
          end
        end
      end
    end
  end
end --largest end chain ever?!?!?!?!?!?!?!?!?!?!?!?!?!?!
function checkSus(i) --stupid code that you can remove if you want
  if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
    if getPropertyFromGroup('unspawnNotes', i, 'mustPress') ~= getPropertyFromGroup('unspawnNotes', i-1, 'mustPress') then
      checkSus(i+1)
      return;
    end
  end
  if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
    setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_assets_3D')
    setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false)
    checkSus(i+1)
  end
end
function onEvent(n, v1, v2)
  if n:lower() == 'change character' then
    shitters = {
      {dadName, 'dad', false, getProperty('dad.cameraPosition')},
      {boyfriendName, 'boyfriend', true, getProperty('boyfriend.cameraPosition')},
      {gfName, 'gf', nil, getProperty('gf.cameraPosition')}
    }
  end
end
function onUpdate(elapsed)
  if not inGameOver then
    elapsedTime = elapsedTime + elapsed;
    for k,v in pairs(floaters) do
      local dontfucking = false
      for i,o in pairs(exclude) do
        if v == o then
          dontfucking = true
        end
      end
      for i,o in pairs(shitters) do
        if v == o[1] and not dontfucking then
          setProperty(o[2]..'.y', getProperty(o[2]..'.y') + math.sin(elapsedTime) * 0.2)
        end
      end
    end
  end
end
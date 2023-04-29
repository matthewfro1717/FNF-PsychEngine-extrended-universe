--custom note skin 4 both player & opponent <3 V2.2
--credit to vCherry.kAI.16 <3 if you remove this text then you're not allowed to use this

  --Handy little guide!
-- "Strums_Texture_P" must exactly match the .png and .xml file you want to use for *YOUR* strums(located in images)
-- "Notes_Texture_P" must exactly match the .png and .xml file you want to use for *YOUR* notes(located in images)
-- "Strums_Texture_O" must exactly match the .png and .xml file you want to use for *THE OPPONENT'S* strums(located in images)
-- "Notes_Texture_O" must exactly match the .png and .xml file you want to use for *THE OPPONENT'S* notes(located in images)
-- "Splashes_Texture" must exactly match the .png and .xml file you want to use for the splashes(located in images)
-- Please put the texture names within the empty apostrophes(aka the '')!
-- If you want to add a custom note type to the list, go to Line 16 and add " or '(note_type)'" after 'GF Sing'


  --REPLACE THESE!!!
local Strums_Texture_P = 'NOTE_assets_3D'
local Notes_Texture_P = 'NOTE_assets_3D'
local Strums_Texture_O = 'NOTE_assets_3D'
local Notes_Texture_O = 'NOTE_assets_3D'
local Splashes_Texture = 'noteSplashes'

function onUpdatePost(elapsed)
  for i = 0, getProperty('opponentStrums.length')-1 do

    setPropertyFromGroup('opponentStrums', i, 'texture', Strums_Texture_O);

    if not getPropertyFromGroup('notes', i, 'mustPress') and getPropertyFromGroup('notes', i, 'noteType') == ('' or 'Hey!' or 'No Animation' or 'GF Sing') then
      setPropertyFromGroup('notes', i, 'texture', Notes_Texture_O);
    end

  end 

  for i = 0, getProperty('playerStrums.length')-1 do

    setPropertyFromGroup('playerStrums', i, 'texture', Strums_Texture_P);

    if getPropertyFromGroup('notes', i, 'mustPress') and getPropertyFromGroup('notes', i, 'noteType') == ('' or 'Hey!' or 'No Animation' or 'GF Sing') then
      setPropertyFromGroup('notes', i, 'texture', Notes_Texture_P);
      setPropertyFromGroup('notes', i, 'noteSplashTexture', Splashes_Texture);
    end
    
  end
end


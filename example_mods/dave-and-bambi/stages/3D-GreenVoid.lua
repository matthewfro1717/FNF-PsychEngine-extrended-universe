--created with Super_Hugo's Stage Editor v1.6.3
local shadname = "glitchEffect";

function onCreate()
    initLuaShader(shadname)

	makeLuaSprite('obj5', '3D_GreenVoid', -2888, -1882)
    setSpriteShader('obj5', shadname)
    setShaderFloat('obj5', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj5', 'uFrequency', 5)
    setShaderFloat('obj5', 'uSpeed', 2)	
    setObjectOrder('obj5', 0)
	scaleObject('obj5', 2.6, 2.6)
	addLuaSprite('obj5', true)

   	makeLuaSprite('obj6', '3D_ExpungedVoid', -2888, -1882)
    setSpriteShader('obj6', shadname)
    setShaderFloat('obj6', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj6', 'uFrequency', 5)
    setShaderFloat('obj6', 'uSpeed', 2)
	setObjectOrder('obj6', 0)
	scaleObject('obj6', 2.6, 2.6)
	addLuaSprite('obj6', true)

end

function onUpdatePost(elapsed)
	setShaderFloat('obj5', 'uTime', os.clock())
	setShaderFloat('obj6', 'uTime', os.clock())
end
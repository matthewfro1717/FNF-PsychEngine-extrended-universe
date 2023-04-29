--created with Super_Hugo's Stage Editor v1.6.3
local shadname = "glitchEffect";

function onCreate()
    initLuaShader(shadname)

	makeLuaSprite('obj4', 'KrembIsland', -9, -300)
	setObjectOrder('obj4', 0)
	scaleObject('obj4', 2, 2)
	addLuaSprite('obj4', true)

	makeLuaSprite('obj5', 'cristals', -600, -300)
	setObjectOrder('obj5', 0)
    doTweenAngle('angle', 'obj5', 808, 303, 'linear');
    setProperty('obj5.angle', 2);
    scaleObject('obj5', 1, 1)
	addLuaSprite('obj5', true)

	makeLuaSprite('obj6', '3D_RedVoid', -1482, -882)
    setSpriteShader('obj6', shadname)
    setShaderFloat('obj6', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj6', 'uFrequency', 5)
    setShaderFloat('obj6', 'uSpeed', 2)
	setObjectOrder('obj6', 0)
	scaleObject('obj6', 2.6, 2.6)
	addLuaSprite('obj6', true)	

end

function onUpdatePost(elapsed)
	setShaderFloat('obj6', 'uTime', os.clock())
end
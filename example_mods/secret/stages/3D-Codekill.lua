--created with Super_Hugo's Stage Editor v1.6.3
local shadname = "glitchEffect";

function onCreate()
    initLuaShader(shadname)

	makeLuaSprite('obj1', 'codingclass', -976, -472)
	setObjectOrder('obj1', 1)
	scaleObject('obj1', 2.5, 2.5)
	addLuaSprite('obj1', true)
    
    makeAnimatedLuaSprite('obj2', 'bg-run', -976, -472) 
    addAnimationByPrefix('obj2', 'run', 'bg-run', 24, true)
    objectPlayAnimation('obj2', 'run', true)
	setObjectOrder('obj2', 1)
	scaleObject('obj2', 2.5, 2.5)
	addLuaSprite('obj2', true)
    
	makeLuaSprite('obj3', 'hall', -976, -472)
	setObjectOrder('obj3', 1)
	scaleObject('obj3', 2.5, 2.5)
	addLuaSprite('obj3', true)

	makeLuaSprite('obj4', 'codingclass', -976, -472)
	setObjectOrder('obj4', 1)
	scaleObject('obj4', 2.5, 2.5)
	addLuaSprite('obj4', true)
    
    makeAnimatedLuaSprite('obj5', 'bg-run', -976, -472) 
    addAnimationByPrefix('obj5', 'run', 'bg-run', 24, true)
    objectPlayAnimation('obj5', 'run', true)
	setObjectOrder('obj5', 1)
	scaleObject('obj5', 2.5, 2.5)
	addLuaSprite('obj5', true)
    
	makeLuaSprite('obj6', 'hall', -976, -472)
	setObjectOrder('obj6', 1)
	scaleObject('obj6', 2.5, 2.5)
	addLuaSprite('obj6', true)

	makeLuaSprite('obj7', 'codingclass', -976, -472)
	setObjectOrder('obj7', 1)
	scaleObject('obj7', 2.5, 2.5)
	addLuaSprite('obj7', true)

	makeLuaSprite('obj8', 'codingclassred', -976, -472)
    setSpriteShader('obj8', shadname)
    setShaderFloat('obj8', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj8', 'uFrequency', 5)
    setShaderFloat('obj8', 'uSpeed', 2)	
	setObjectOrder('obj8', 1)
	scaleObject('obj8', 2.5, 2.5)
	addLuaSprite('obj8', true)

	makeLuaSprite('obj9', 'speis', -2002, -888)
    setSpriteShader('obj9', shadname)
    setShaderFloat('obj9', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj9', 'uFrequency', 5)
    setShaderFloat('obj9', 'uSpeed', 2)
	setObjectOrder('obj9', 1)
	scaleObject('obj9', 2.6, 2.6)
	addLuaSprite('obj9', true)

end

function onUpdatePost(elapsed)
	setShaderFloat('obj8', 'uTime', os.clock())
	setShaderFloat('obj9', 'uTime', os.clock())
end
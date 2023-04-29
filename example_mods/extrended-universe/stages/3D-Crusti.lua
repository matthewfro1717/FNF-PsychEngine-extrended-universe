--created with Super_Hugo's Stage Editor v1.6.3
local shadname = "glitchEffect";

function onCreate()

	makeLuaSprite('obj4', 'PizzaBox', -100, -646)
	setObjectOrder('obj4', 0)
	scaleObject('obj4', 2.5, 2.5)
	addLuaSprite('obj4', true)
	
	makeLuaSprite('obj5', '3D_Pizzas', -1440, -1100)      
    initLuaShader(shadname)
    setSpriteShader('obj5', shadname)
    setShaderFloat('obj5', 'uWaveAmplitude', 0.1)
    setShaderFloat('obj5', 'uFrequency', 5)
    setShaderFloat('obj5', 'uSpeed', 2)
	setObjectOrder('obj5', 0)
	scaleObject('obj5', 2.6, 2.6)
	addLuaSprite('obj5', true)
	
end

function onUpdatePost(elapsed)
	setShaderFloat('obj5', 'uTime', os.clock())
end
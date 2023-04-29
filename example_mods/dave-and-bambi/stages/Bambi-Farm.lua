function onCreate()
	-- background shit
	makeLuaSprite('sky', 'sky', -600, -300);
	setScrollFactor('sky', 0.65, 0.65);
	
	makeLuaSprite('gm_flatgrass', 'gm_flatgrass', 350, 75);
	setScrollFactor('gm_flatgrass', 0.65, 0.65);
	scaleObject('gm_flatgrass', 0.65, 0.65);
	
	makeLuaSprite('orangey hills', 'orangey hills', -173, 100);
	setScrollFactor('orangey hills', 0.65, 0.65);
	
	makeLuaSprite('funfarmhouse', 'funfarmhouse', 100, 125);
	setScrollFactor('funfarmhouse', 0.65, 0.65);
	
	makeLuaSprite('grass lands', 'grass lands', -600, 500);
	setScrollFactor('grass lands', 1, 1);
	
	makeLuaSprite('cornFence', 'cornFence', -400, 200);
	setScrollFactor('cornFence', 1, 1);
	
	makeLuaSprite('cornFence2', 'cornFence2', 1100, 200);
	setScrollFactor('cornFence2', 1, 1);

	makeLuaSprite('cornbag', 'cornbag', 1200, 550);
	setScrollFactor('cornbag', 1, 1);
	
	makeLuaSprite('sign', 'sign', 0, 350);
	setScrollFactor('sign', 1, 1);

	addLuaSprite('sky', false);
	addLuaSprite('gm_flatgrass', false);
	addLuaSprite('orangey hills', false);
	addLuaSprite('funfarmhouse', false);
	addLuaSprite('grass lands', false);
	addLuaSprite('cornFence', false);
	addLuaSprite('cornFence2', false);
	addLuaSprite('cornbag', false);
	addLuaSprite('sign', false);


	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
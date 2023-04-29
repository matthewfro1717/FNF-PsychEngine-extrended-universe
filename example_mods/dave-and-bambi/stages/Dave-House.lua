function onCreate()
	-- background shit
	makeLuaSprite('sky', 'sky', -600, -300);
	setScrollFactor('sky', 0.6, 0.6);
	
	makeLuaSprite('hills', 'hills', -834, -159);
	setScrollFactor('hills', 0.7, 0.7);
	
	makeLuaSprite('grass bg', 'grass bg', -1205, 580);
	setScrollFactor('grass bg', 1, 1);
	
	makeLuaSprite('gate', 'gate', -555, 250);
	scaleObject('gate', 1, 1);
	
	makeLuaSprite('grass', 'grass', -600, 500);



	addLuaSprite('sky', false);
	addLuaSprite('hills', false);
	addLuaSprite('grass bg', false);
	addLuaSprite('gate', false);
	addLuaSprite('grass', false);


	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
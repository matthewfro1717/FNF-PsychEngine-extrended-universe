function onCreatePost()

    makeLuaText('counter', judgeCountTxt, 0, 10, 360);
    setTextFont('counter', 'extrended.ttf');
    setTextSize('counter', 21);
    setTextAlignment('counter', 'left');
    addLuaText('counter');

	makeLuaText('song', songName .. '', 0, 2, 700);
	setTextFont('song','extrended.ttf');
	setTextSize('song', 18);
	addLuaText('song');

    makeLuaText('ver', 'Extrended Universe Engine', 0, 0, 0);
	setTextFont('ver', 'extrended.ttf');
    setPosition('ver', screenWidth - (getProperty('ver.width') + 5), 5);
	addLuaText('ver');

	if not downscroll then
	    setProperty('ver.y', 10);
	    setProperty('rating.y', 680);
	    setProperty('miss.y', 640);
	    setProperty('score.y', 620);
    end
    addHaxeLibrary('Main');
runHaxeCode([[
        Main.fpsVar.defaultTextFormat = new openfl.text.TextFormat("extrended.ttf", 16, -1);
    ]]);
end

function setPosition(obj, x, y)
    setProperty(obj..'.x', x);
    setProperty(obj..'.y', y);
end

function floorDecimal(value, decimals) -- Port of Highscore.floorDecimal() lmao
    if decimals < 1 then
        return math.floor(value);
    end

    local tempMult = 1;
    for i = 1, decimals do
        tempMult = tempMult * 10;
    end
    local newValue = math.floor(value * tempMult);
    return newValue / tempMult;
end
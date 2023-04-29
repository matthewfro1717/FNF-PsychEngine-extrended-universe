function onCreatePost()
    setObjectOrder('healthBarBG', getObjectOrder('healthBar'))
    
    screenCenter('timeBar', 'X')
    setProperty('timeBar.y', getProperty('timeBar.y') + 5)
    addHaxeLibrary('FlxBar', 'flixel.ui')
    setObjectOrder('timeBarBG', getObjectOrder('timeBar'))
end
_ENV = {
	_G      = _G,
	require = require,
	collectgarbage = collectgarbage
}

Button = require('app.Button')
waves  = require('res.waves')
grid   = require('tic.grid')

function on_draw()
	grid.draw()
	b1:draw()
end

function on_touch(x, y) 
	if b1:contains(x, y) then 
		exit()
		require('title.screen').show()
	else
		grid.on_touch(x, y)
	end
end

function show()
	grid.init()
	b1 = Button.create_from_text('Back to Title', 50, 30)
	music = waves.get('music/AgoraCastleIntro.wav'):loop()
	_G.on_draw  = on_draw
	_G.on_touch = on_touch
end

function exit()
	music:stop() 
	music = nil
	b1 = nil
	b2 = nil
	_G.on_draw  = nil
	_G.on_touch = nil
	collectgarbage()
end

return {
	show = show,
	exit = exit
}


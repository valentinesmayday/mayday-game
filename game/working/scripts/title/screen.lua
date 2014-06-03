_ENV = {
	_G             = _G,
	require        = require,
	quit           = quit,
	collectgarbage = collectgarbage,
	package        = package
}
Button = require('app.Button')
waves  = require('res.waves')
sf     = require('app.savefile')

function on_draw()
	new_story:draw()
	exit_app:draw()
end

function on_touch(x, y) 
	if new_story:contains(x, y) then 
		sf.clear()
		sf.current_node = 'start'
		hide()
		require('story.screen').show()
	elseif exit_app:contains(x, y) then
		hide()
		quit()
	end
end

function show()
	new_story = Button.create_from_text('New Story', 100, 100)
	--continue  = Button.create_from_text('Continue Story', new_story.x, new_story.y + 32)
	--tic       = Button.create_from_text('Tic Tac Toe', continue.x, continue.y + 32)
	--play_door = Button.create_from_text('Play sound.', tic.x, tic.y + 32)
	exit_app  = Button.create_from_text('Exit', 100, 132)
	music     = waves.get('music/Overworld.wav'):loop()
	door      = waves.get('waves/Door.wav')
	_G.on_draw  = on_draw
	_G.on_touch = on_touch
end

function hide()
	music = nil
	b1 = nil
	b2 = nil
	b3 = nil
	b4 = nil
	_G.on_draw  = nil
	_G.on_touch = nil
	collectgarbage()
end

return {
	show  = show
}



_ENV = {
	_G		= _G,
	require 	= require,
	load            = load,
	pcall           = pcall,
	msgbox          = msgbox,
	collectgarbage	= collectgarbage,
	package         = package,
	load_chunk      = load_chunk,
	read_file       = read_file,
	write_file      = write_file
}

Button      = require('app.Button')
textures    = require('res.textures')
dialog_font = require('res.fonts').get('dialog')
waves       = require('res.waves')
sf          = require('app.savefile')

if not sf.current_node then
	sf.current_node = 'start'
end

function on_draw()
	if p        then  p:draw(400, 220) end
	if a1       then a1:draw(50,  50)  end
	if a2       then a2:draw(50,  80)  end
	if a3	    then a3:draw(50,  110) end
	if a4	    then a4:draw(50,  140) end
	if a5	    then a5:draw(50,  170) end
	if a6	    then a6:draw(400, 450) end
	if b1       then b1:draw()         end
	if b2       then b2:draw()         end
	if b3	    then b3:draw()	   end
	if b4	    then b4:draw()	   end
	if exit_btn then exit_btn:draw()   end
end

-- On R key down, reload the story screen.
function on_keydown_r()
	hide()
	show()
end

function hide()
	m                = nil
	mi               = nil
	p                = nil
        a1               = nil
        a2               = nil
        a3		 = nil
	a4               = nil 
	a5               = nil
	a6		 = nil
   	b1               = nil
        b2               = nil
	b3		 = nil
	b4		 = nil
        c1               = nil
        c2          	 = nil
	c3               = nil
	c4		 = nil
        f1               = nil
        f2               = nil
	f3		 = nil
	_G.on_draw       = nil
	_G.on_touch      = nil
	_G.on_keydown_r  = nil
	collectgarbage()
end

function on_touch(x, y) 
	if exit_btn and exit_btn:contains(x, y) then 
		hide()
		require('title.screen').show()
	elseif b1 and b1:contains(x, y) then 
		if f1 then f1() end
		goto_node(c1)
	elseif b2 and b2:contains(x, y) then 
		if f2 then f2() end
		goto_node(c2) 
	elseif b3 and b3:contains(x, y) then
		if f3 then f3() end
		goto_node(c3)
	elseif b4 and b4:contains(x, y) then
		if f4 then f4() end
		goto_node(c4)
	end
end

function show()
	exit_btn        = Button.create_from_text('Exit', 40, 450)
	_G.on_draw      = on_draw
	_G.on_touch     = on_touch
	_G.on_keydown_r = on_keydown_r
	goto_node(sf.current_node)
end

function end_story()
	sf.clear()
	sf.current_node = 'start'
	hide()
	require('title.screen').show()
end

function goto_node(node)
	if not node then 
		end_story() 
		return
	end
	local chunk = load_chunk('nodes/' .. node .. '.lua')
	if not chunk then
		msgbox(file .. ' not found.') 
		return 
	end
	local env = { sf = sf }
	local n, msg = load(chunk, nil, 't', env)
	if not n then 
		msgbox(msg)
		return 
	end
	local status, msg = pcall(n)
	if not status then 
		msgbox(msg)
		return 
	end

	p  = env.p  and textures.image('portraits/' .. env.p .. '.bmp')

	a1 = env.a1 and textures.text(env.a1, dialog_font)
	a2 = env.a2 and textures.text(env.a2, dialog_font)
	a3 = env.a3 and textures.text(env.a3, dialog_font)
	a4 = env.a4 and textures.text(env.a4, dialog_font)
	a5 = env.a5 and textures.text(env.a5, dialog_font)
	a6 = env.a6 and textures.text(env.a6, dialog_font)
	

	b1 = env.b1 and Button.create_from_text('a) ' .. env.b1, 50, 300)
	b2 = env.b2 and Button.create_from_text('b) ' .. env.b2, 50, 340)
	b3 = env.b3 and Button.create_from_text('c) ' .. env.b3, 50, 380)
	b4 = env.b4 and Button.create_from_text('d) ' .. env.b4, 50, 420)

	c1 = b1 and env.c1 
	c2 = b2 and env.c2 
	c3 = b3 and env.c3
	c4 = b4 and env.c4
	f1 = c1 and env.f1
	f2 = c2 and env.f2
	f3 = c3 and env.f3
	f4 = c4 and env.f4

	if not env.m then 
		m  = nil
		mi = nil
	elseif m ~= env.m then
		m  = env.m
		if mi then mi:stop() end
		w = waves.get('music/' .. m .. '.wav')
		if w then
			mi = w:loop()
		else
			msgbox('Unknown music: ' .. m)
			m = nil
		end
	end
	collectgarbage()  

	sf.current_node = node
end
		

return {
	show = show
}


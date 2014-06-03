local waves = {}
setmetatable(waves, { __mode = 'v' })

local loop_instance_mt = {}

loop_instance_mt.__index = loop_instance_mt

function loop_instance_mt:stop()
	if self.i and not self.stopped then
		self.stopped = true
		stop_loop(self.i)
	end
end

function loop_instance_mt:__gc()
	if self.i and not self.stopped then stop_loop(self.i) end
end

local wave_mt = {}

wave_mt.__index = wave_mt;

function wave_mt:__gc()
	destroy_wave(self.w)
	waves[self.filename] = nil
end

function wave_mt:play()
	play_wave(self.w) 
end

function wave_mt:loop()
	local loop_instance = { i = loop_wave(self.w) }
	setmetatable(loop_instance, loop_instance_mt)
	return loop_instance
end

local function get(filename)
	if waves[filename] then 
		return waves[filename]
	end
	local o = { filename = filename }
	o.w = wave_from_file(filename)
	setmetatable(o, wave_mt)
	waves[filename] = o
	return o
end

return {
	get = get
}


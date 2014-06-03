_ENV = {
	_G             = _G,
	require        = require,
	set_draw_color = set_draw_color,
	draw_line      = draw_line,
	setmetatable   = setmetatable,
	math           = math,
	msgbox         = msgbox
}

Button = require('app.Button')

x1 = 100
x2 = 200
x3 = 300
x4 = 400

y1 = 100
y2 = 200
y3 = 300
y4 = 400

grid_pos_x = 100
grid_pos_y = 100
cell_size = 100

function draw_x(x, y)
	draw_line(x + 30, y + 30, x + 70, y + 70)
	draw_line(x + 70, y + 30, x + 30, y + 70)
end

function draw_o(x, y)
	draw_line(x + 30, y + 30, x + 70, y + 30)
	draw_line(x + 30, y + 30, x + 30, y + 70)
	draw_line(x + 70, y + 30, x + 70, y + 70)
	draw_line(x + 30, y + 70, x + 70, y + 70)
end

-- Define metatable for grid cells.
mt = {}
mt.__index = mt
function mt:draw()
	if     self.mark == 'x' then draw_x(self.x, self.y)
	elseif self.mark == 'o' then draw_o(self.x, self.y)
	end
end

c = {}  -- grid cells
game_over = false
game_status = Button.create_from_text("Your move.", 30, 420)

function draw()
	set_draw_color(255, 255, 255, 255)
	draw_line(x1, y2, x4, y2)
	draw_line(x1, y3, x4, y3)
	draw_line(x2, y1, x2, y4)
	draw_line(x3, y1, x3, y4)
	for row = 1, 3 do
		for col = 1, 3 do
			c[col][row]:draw()
		end
	end
	game_status:draw()
end

function is_row_complete(row, mark)
	return 	c[1][row].mark == mark and 
		c[2][row].mark == mark and 
		c[3][row].mark == mark 
end

function is_column_complete(col, mark)
	return 	c[col][1].mark == mark and 
		c[col][2].mark == mark and 
		c[col][3].mark == mark 
end

function is_diagonal_complete(mark)
	return	c[1][1].mark == mark and c[2][2].mark == mark and c[3][3].mark == mark or
		c[3][1].mark == mark and c[2][2].mark == mark and c[1][3].mark == mark 
end

function is_winner(mark) 
	for row = 1, 3 do
		if is_row_complete(row, mark) then return true end
	end
	for col = 1, 3 do
		if is_column_complete(col, mark) then return true end
	end
	if is_diagonal_complete(mark) then return true end
	return false
end

function is_player_winner() 
	return is_winner('x')
end

function is_computer_winner() 
	return is_winner('o')
end

function is_tie_game() 
	if is_player_winner() then return false end
	if is_computer_winner() then return false end
	for row = 1, 3 do
		for col = 1, 3 do
			if not c[col][row].mark then return false end
		end
	end
	return true
end

function evaluate_game() 
	if is_player_winner() then
		game_status = Button.create_from_text('You win.', game_status.x, game_status.y)
		game_over = true
	elseif is_computer_winner() then
		game_status = Button.create_from_text('Computer wins.', game_status.x, game_status.y)
		game_over = true
	elseif is_tie_game() then
		game_status = Button.create_from_text('Tie game.', game_status.x, game_status.y)
		game_over = true
	end
end

function do_computer_turn() 
	if not c[2][2].mark then 
		c[2][2].mark = 'o'
		return
	end
	-- Make a random move.
	local available = {}
	for row = 1, 3 do
		for col = 1, 3 do
			if not c[col][row].mark then 
				available[#available + 1] = { col = col, row = row } 
			end
		end
	end
	local i = math.random(#available)
	c[available[i].col][available[i].row].mark = 'o'
end

function on_touch(x, y)
	if game_over then return end
	if x < grid_pos_x or x > grid_pos_x + 3 * cell_size then return end
	if y < grid_pos_y or y > grid_pos_y + 3 * cell_size then return end
	local col = math.floor((x - 100) / 100) + 1
	local row = math.floor((y - 100) / 100) + 1
	if c[col][row].mark then return end
	c[col][row].mark = 'x'
	evaluate_game()
	if not game_over then
		do_computer_turn()
		evaluate_game()
	end
end

function init()
	game_over = false
	for col = 1, 3 do
		c[col] = {}
		for row = 1, 3 do
			c[col][row] = { 
				x = grid_pos_x + cell_size * (col - 1), 
				y = grid_pos_y + cell_size * (row - 1)
			}
			setmetatable(c[col][row], mt)
		end
	end
end


return {
	init     = init,
	draw     = draw,
	on_touch = on_touch
}


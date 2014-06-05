p = 'Mall'
m = 'Overworld'

a1 = 'You are at Tickets R Us.'
a2 = ' What will you buy?'

b1 = 'Katy Perry Tickets'
b2 = 'Rihanna Tickets'
b3 = 'Justin Timberlake Tickets'
b4 = 'Go back'

c1 = 'endings/end'
c2 = 'endings/end'
c3 = 'endings/end'

sf.timer = sf.timer - 15

if sf.timer <= 0 then
	c4 = 'endings/badending'
else
	c4 = 'shop/n3'
end

f1 = function()
	sf.grade = 'D'
end

f2 = function()
	sf.grade = 'B+'
end

f3 = function()
	sf.grade = 'S'
end

a6 = 'Time left = ' .. sf.timer
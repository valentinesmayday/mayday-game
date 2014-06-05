p = 'Mall'
m = 'Overworld'

a1 = 'You are at Novelty B Poppin.'
a2 = ' What will you buy?'

b1 = 'Miley Foam Finger'
b2 = 'Robin Thicke Sunglasses'
b3 = 'Justin Timberlake Poster'
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
	sf.grade = 'B-'
end

f2 = function()
	sf.grade = 'F'
end

f3 = function()
	sf.grade = 'A-'
end

a6 = 'Time left = ' .. sf.timer
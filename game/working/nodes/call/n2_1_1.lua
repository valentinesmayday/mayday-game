p = 'Brad'
m = 'Overworld'

a1 = 'Brad: Uhh... Maybe some pop music? She does not'
a2 = '   have CDs anymore and I do not have access to'
a3 = '   her music.'
a4 = 'You: Thanks...'

b1 = 'Continue'

if sf.timer <= 2 then
	c1 = 'endings/badending'
else
	c1 = 'n1'
end

sf.timer = sf.timer - 2

a6 = 'Time left = ' .. sf.timer
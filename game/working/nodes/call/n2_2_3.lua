p = 'Lola'
m = 'Overworld'

a1 = 'You: Yeah yeah, I know!'
a2 = 'Lola: Well, she does want to go to a concert!'
a3 = 'You: Oh cool! That helps out a lot! Thanks!'
a4 = 'Lola: You are welcome! You better not mess this up'
a5 = '  by getting her tickets to Lil Wayne or something!'

b1 = 'Continue'

if sf.timer <= 2 then
	c1 = 'endings/badending'
else
	c1 = 'n1'
end

sf.timer = sf.timer - 2

a6 = 'Time left = ' .. sf.timer
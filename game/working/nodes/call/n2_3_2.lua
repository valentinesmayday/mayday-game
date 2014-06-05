p = 'MrsHarvey'
m = 'Overworld'

a1 = 'Mrs. Harvey: Let me check her room.'
a2 = '    (*10 minutes pass*)'
a3 = 'Mrs. Harvey: I noticed a Justin Timberlake poster in'
a4 = '  her room. Does that help?'
a5 = 'You: Great! Yes, thanks so much Mrs. Harvey!'

b1 = 'Continue'

if sf.timer <= 11 then
	c1 = 'endings/badending'
else
	c1 = 'n1'
end

sf.timer = sf.timer - 11

a6 = 'Time left = ' .. sf.timer
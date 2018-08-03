import requests
import sys

jsarr = [
	'./calendar.skip.js','./pagination.skip.js'
]
auth = ['* EITS Javascript Calendar for Twitter Boostrap v3.3.7', '* EITS Javascript Calendar Pagination for Twitter Boostrap v3.3.7']
count = 0;
author = "Bryan Chasteen (chasteen at the University of Georgia)"

for js in jsarr:
	r = requests.post('https://javascript-minifier.com/raw', data = { 'input' : open(js, 'rb').read()})
	heading = "/**\n" + auth[count] + "\n* Author " + author + "\n* Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE)\n*/\n"
	
	
	minified = js.rstrip('.skip.js') + '.min.js'
	with open(minified, 'w') as m:
		m.write(heading + r.text)

	print("Minification complete. See {}" . format(m.name))
	count += 1

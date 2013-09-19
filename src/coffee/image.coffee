debug = (require 'debug')('Image')

class Image
	constructor: (props) ->
		
		# todo
	resize: () ->
		# todo
	@query: (page, min, max) ->

# data structure roughly as follows:
structure =
	created: new Date()
	filename: ''
	rating: '' # safe, questionable, explicit, unknown
	hashes:
		md5: ''
		sha1: ''
	size:
		filesize: 0
		height: 0
		width: 0
	thumb:
		height: 0
		width: 0
		filename: ''
	sources: ['']
	tags: ['']

# end structure


module.exports = Image

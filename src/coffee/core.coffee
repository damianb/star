{EventEmitter} = require 'events'
qs = require 'querystring'
url = require 'url'

async = require 'async'
debug = (require 'debug')('core')
nedb  = require 'nedb'
request = require 'request'

{ gui } = global

class core extends EventEmitter
	constructor: ->
		@appTokens = {}
			# todo populate if necessary

		@pkg = gui.App.manifest

		# todo image nedb database
		@db = new nedb { autoload: true, nodeWebkitAppName: 'star', filename: 'images.db' }

		# image data structure roughly as follows:
		imageStructure =
			created: Date.now()
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

		@tagDb = new nedb { autoload: true, nodeWebkitAppName: 'star', filename: 'tags.db' }
		tagStructure =
			type: '' # author, copyright, series, character, unknown
			tag: ''
		# todo: index constraints

module.exports = new core()

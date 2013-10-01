#
# - special requires
#

fs = require 'fs'
domain = require 'domain'
debug = (require 'debug')('client')

#
# - global object prototype modifications...
#

global.Array::remove = Array::remove = (from, to) ->
	rest = @slice (to or from) + 1 or @length
	@length = if from < 0 then @length + from else from
	@push.apply @, rest

global.Array::has = Array::has = (entries...) ->
	hasEntries = true
	process = =>
		if (@indexOf entries.shift()) is -1
			hasEntries = false
	process() until hasEntries is false or entries.length is 0
	hasEntries

# todo remove?
escapeHTML = require 'escape-html'
global.String::escapeHTML = String::escapeHTML = ->
	escapeHTML @

dateFormat = require 'dateformat'
global.Date::format = Date::format = (mask, utc) ->
	dateFormat @, mask, utc

# global muckery...yuck. ;_;

global.$ = $
global.gui = gui = require 'nw.gui'

# crit logging
global.handleCrit = (err) ->
	debug 'critical: ' + err
	console.error err
	fs.appendFileSync './error.log', "#{new Date()}\n #{err.stack}\n"
	process.exit 1

process.on 'uncaughtException', global.handleCrit

# initially, we are NOT in debug mode. we have to key-sequence our way into debug mode, and answer
# a series of three questions to the Keeper of the Bridge, else we be cast into the depths beyond.
DEBUG = false

curwindow = gui.Window.get()

# working around a node-webkit bug on windows
# ref: https://github.com/rogerwang/node-webkit/issues/253
curwindow.on 'minimize', ->
	width = curwindow.width
	curwindow.once 'restore', ->
		if curwindow.width isnt width then curwindow.width = width

d = domain.create()
d.on 'error', global.handleCrit

# handling drag/drop "uploads"
handleUpload = (image) ->
	image.ondragover = ->
		image.addClass 'hover'
		false
	image.ondragend = ->
		image.removeClass 'hover'
		false
	image.ondrop = (e) ->
		e.preventDefault()
		image.removeClass 'hover'
		#files = e.originalEvent.dataTransfer.files
		files = e.dataTransfer.files

		if files.length > 1
			# todo: error - multiple file uploading isn't supported
			false

		if files.length is 0
			# todo: error - no file dragged?
			false

		file = files.shift()
		# todo: work with file.path here

d.run ->

	#
	# - special key binds
	# - there will be no compromise. these will not be allowed to be used
	#

	$(document).on 'keydown', null, 'ctrl+F12', ->
		DEBUG = !DEBUG
		$('footer').toggle()

	$(document).on 'keydown', null, 'ctrl+j', ->
		if DEBUG
			gui.Window.get().showDevTools()
	$(document).on 'keydown', null, 'ctrl+r', ->
		if DEBUG
			gui.Window.get().reloadIgnoringCache()

	#
	# - ui binds
	#

	$().ready ->
		$('#version').text("nw #{process.versions['node-webkit']}; node #{process.version}")
		$('footer').hide()
		$('.reldate').relatizeDateTime()
		setInterval ->
			$('.reldate').relatizeDateTime()
		, 45 # todo, maybe make 15 second intervals?

controllers = require './controllers'
debug = (require 'debug')('app')
nedb  = require 'nedb'
{ gui } = global

angular.module('starCore', [])
	.factory('core', ->
		return global.star
	)
	.factory('imagesDb', ->
		db = new nedb { autoload: true, nodeWebkitAppName: 'star', filename: 'images.db' }
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
		# todo constraints

		return db
	)
	.factory('tagDb', ->
		db = new nedb { autoload: true, nodeWebkitAppName: 'star', filename: 'tags.db' }
		tagStructure =
			type: '' # author, copyright, series, character, unknown
			tag: ''
		# todo constraints

		return db
	)
	.factory('manifest', ->
		return gui.App.manifest
	)

angular.module('star', ['starCore'])
	.config(['$routeProvider', ($routeProvider) ->
		# define routes
		$routeProvider
			.when('/404', { templateUrl: 'templates/404.html' })
			.when('/image', { redirectTo: '/list' })
			.when('/', { templateUrl: 'templates/ImageList.html', controller: controllers.ImageList })
			.when('/list', { templateUrl: 'templates/ImageList.html', controller: controllers.ImageList })
			.when('/list/:page', { templateUrl: 'templates/ImageList.html', controller: controllers.ImageList })

			#.when('/image/new', { templateUrl: 'templates/latest.html', controller: controllers.ImageNew })
			#.when('/image/import', { templateUrl: 'templates/latest.html', controller: controllers.ImageImport })
			.when('/image/:imageId', { templateUrl: 'templates/ImageView.html', controller: controllers.ImageView })
			#.when('/image/:imageId/edit', { templateUrl: '', controller: controllers.ImageEdit })
			.otherwise({redirectTo: '/404'}) # todo change?
	])

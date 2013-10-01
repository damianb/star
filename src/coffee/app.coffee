controllers = require './assets/js/star/controllers'
debug = (require 'debug')('app')
nedb = require 'nedb'
{ gui } = global

angular.module('starCore', [])
	.factory('gui', ->
		gui
	)
	.factory('manifest', ->
		gui.App.manifest
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

		db
	)
	.factory('tagDb', ->
		db = new nedb { autoload: true, nodeWebkitAppName: 'star', filename: 'tags.db' }
		tagStructure =
			type: '' # author, copyright, series, character, unknown
			tag: ''
		# todo constraints

		db
	)

angular.module('star', ['starCore'])
	.config(['$locationProvider', ($locationProvider) ->
		$locationProvider.html5Mode false
		$locationProvider.hashPrefix '!'
	])
	.config(['$routeProvider', ($routeProvider) ->
		# define routes
		$routeProvider
			.when('/404', { templateUrl: './assets/templates/404.html' })
			.when('/image', { redirectTo: '/list' })
			.when('/', { templateUrl: './assets/templates/ImageList.html', controller: controllers.ImageList })
			.when('/list', { templateUrl: './assets/templates/ImageList.html', controller: controllers.ImageList })
			.when('/list/:page', { templateUrl: './assets/templates/ImageList.html', controller: controllers.ImageList })

			#.when('/image/new', { templateUrl: './assets/templates/latest.html', controller: controllers.ImageNew })
			#.when('/image/import', { templateUrl: './assets/templates/latest.html', controller: controllers.ImageImport })
			.when('/image/:imageId', { templateUrl: './assets/templates/ImageView.html', controller: controllers.ImageView })
			#.when('/image/:imageId/edit', { templateUrl: '', controller: controllers.ImageEdit })
			.otherwise({redirectTo: '/404'}) # todo change?
	])

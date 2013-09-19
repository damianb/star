controllers = require './controllers'
{ star } = global

angular.module('starCore', [])
	.factory('core', ->
		return global.star
	)

angular.module('star', ['starCore'])
	.config(['$routeProvider', ($routeProvider) ->
		# define routes
		$routeProvider
			.when('/404', { templateUrl: 'templates/404.html' })
			.when('/image', { redirectTo: '/list' })
			.when('/', { templateUrl: 'templates/latest.html', controller: controllers.ImageList })
			.when('/list', { templateUrl: 'templates/latest.html', controller: controllers.ImageList })
			.when('/list/:page', { templateUrl: 'templates/latest.html', controller: controllers.ImageList })

			#.when('/image/new', { templateUrl: 'templates/latest.html', controller: controllers.ImageNew })
			#.when('/image/import', { templateUrl: 'templates/latest.html', controller: controllers.ImageImport })
			.when('/image/:imageId', { templateUrl: 'templates/image_view.html', controller: controllers.ImageView })
			#.when('/image/:imageId/edit', { templateUrl: '', controller: controllers.ImageEdit })
			.otherwise({redirectTo: '/404'}) # todo change?
	])

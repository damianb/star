controllers.ImageView = ($scope, $routeParams, core) ->
	# todo valiate that $routeParams.imageId is a string
	core.db.find { _id: $routeParams.imageId }, (err, doc) ->
		if err
			# todo: do something
			return

		if !doc?
			# welp, no image
			$scope.image = null
			$scope.noImage = true
		else if !doc.thumb
			# not processed.
			# todo: check to see if it's in the queue perhaps?
			$scope.image = doc
			$scope.processed = false
		else
			$scope.processed = true
			$scope.image = doc

controllers.ImageView.$inject = ['$scope', '$routeParams', 'core']

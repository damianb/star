controllers.ListImages = ($scope, $routeParams, core) ->
	# shim it.
	if !$routeParams.page? then $routeParams.page = 1

	$scope.images = []
	$scope.page = $routeParams.page
	$scope.pagination = []
	# we're going to be humane and use 1-indexed pages,
	# but we still need to use 0-indexed counts internally.
	page = $routeParams.page - 1

	perPage = 20
	total = 0
	floor = perPage * page
	ceil = (perPage + 1) * page

	# we're restricting this to just stuff that has a thumbnail for now,
	# because if it doesn't have a thumbnail, it's probably being processed still.
	core.db.find { thumb: { $ne: null } }, (err, docs) ->
		if err
			# todo: do something
			return

		$scope.total = total = docs.length
		docs = docs.sort (a, b) ->
			if a.created is b.created
				return 0
			else
				return a.created > b.created ? 1 : -1

		$scope.images = docs.slice floor, ceil

		# calculate pagination - we'll go by +/- 5.
		floor = page - 5
		ceil = page + 5
		pagination = []
		for i in [floor..ceil]
			if i >= 0 and ((i - 1) * perPage) <= total
				pagination.push (i + 1)
		# only update this at the very end of iteration
		$scope.pagination = pagination

controllers.ListImages.$inject = ['$scope', '$routeParams', 'core']

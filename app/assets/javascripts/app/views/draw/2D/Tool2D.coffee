class CC.views.draw.Tool2D extends CC.views.Abstract
	@active
	@path
	@stage2d
	constructor:(stage)->
		@stage2d = stage
		@path = stage.path
		@active = false
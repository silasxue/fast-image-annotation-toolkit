class Shape
    constructor: (@canvas, @x, @y, @w, @h, @color = '#AAA') ->

    draw: (canvas = @canvas) ->
        canvas.context.fillStyle = @color
        canvas.context.fillRect @x, @y, @w, @h

    contains: (mx, my) ->
        (@x <= mx) and (@x + @w >= mx) and
        (@y <= my) and (@y + @h >= my)

    isOutsideCanvas: (canvas = @canvas) ->
        return @x > canvas.width or @y > canvas.height or @x + @w < 0 or @y + @h < 0

    setCenter: (cx, cy) ->
        @x = cx - @w/2
        @y = cy - @h/2

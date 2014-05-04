class SideBar
    # @sidebar: jQuery view object
    constructor: (@sidebar) ->
        @textArea = @sidebar.find '.annotations-meta-info'
        @isModalShown = false

        tags = localStorage.getItem('tags')
        if tags != null
            @tags = JSON.parse tags
        else
            @tags = []

        selectedTags = localStorage.getItem('selectedTags')
        if tags != null
            @selectedTags = JSON.parse selectedTags
        else
            @selectedTags = []

        @initializeEvents()
        @initializeTagsView()

    initializeEvents: ->
        @sidebar.find('button.unselect').click (e) =>
            @sidebar.find('.tags select').val []
        @sidebar.find('button.edit-tags').click (e) =>
            @sidebar.find('.editable-tags').html($('<textarea>'))
            @sidebar.find('.editable-tags').append($('<button>Save</button>'))
            @sidebar.find('.editable-tags textarea').val((JSON.stringify @tags).replace(/[\"\[\]]+/g, ''))
            @sidebar.find('.editable-tags button').click =>
                try
                    tags = @sidebar.find('.editable-tags textarea').val()
                        .replace(/^\s*|\s*$/g,'').split(/\s*,\s*/)
                    localStorage.setItem('tags', JSON.stringify tags)
                    @tags = tags

                @initializeTagsView()
                @sidebar.find('.editable-tags').hide()
                @sidebar.find('.tags').show()

            @sidebar.find('.tags').hide()
            @sidebar.find('.editable-tags').show()

    initializeTagsView: =>
        @sidebar.find('.tags').html($('<select>', {class:'form-control', multiple:''}))
        for tag in @tags
            @sidebar.find('.tags select').append $("<option>#{tag}</option>")

        @sidebar.find('.tags select').click =>
            @selectedTags = @sidebar.find('.tags select').val()
            localStorage.setItem('selectedTags', JSON.stringify @selectedTags)
            @setMetaData()

        @sidebar.find('.tags select').val @selectedTags


    setMetaData: (components=@components) =>
        @components=components
        data = components:[], tags:[]

        for tag in @selectedTags
            data.tags.push tag

        if components?
            getOrigin = =>
                for component in components
                    if component.constructor.name is 'CanvasImage'
                        return component.getCenter()
                return x:0, y:0
            origin = getOrigin()

            for component in components
                data.components.push switch component.constructor.name
                    when 'CanvasImage'
                        type: 'image'
                        centerX: component.centerX
                        centerY: component.centerY
                        w: component.w
                        h: component.h
                        orientation: component.orientation
                    when 'ResizableRectangle'
                        type: 'rectangle'
                        x: component.x - origin.x
                        y: component.y - origin.y
                        w: component.w
                        h: component.h
                        label: component.getLabel()

        @textArea.val JSON.stringify data, null, 2 # indentation

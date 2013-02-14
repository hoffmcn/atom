{View} = require 'space-pen'
fs = require 'fs'
OperationView = require './operation-view'
$ = require 'jquery'

module.exports =
class PathView extends View
  @content: ({path, operations} = {}) ->
    classes = ['path']
    classes.push('readme') if fs.isReadmePath(path)
    @li class: classes.join(' '), =>
      @span class: 'path-name', path
      @span "(#{operations.length})", class: 'path-match-number'
      @ul outlet: 'matches', class: 'matches', =>
        for operation in operations
          @subview "operation#{operation.index}", new OperationView({operation})

  initialize: ->
    @on 'mousedown', @onPathSelected
    rootView.command 'command-panel:collapse-result', (e) =>
      @collapse(true) if @find('.selected').length

  onPathSelected: (event) =>
    e = $(event.target)
    e = e.parent() if e.parent().hasClass 'path'
    @toggle(true) if e.hasClass 'path'

  toggle: (animate) ->
    if @hasClass('is-collapsed')
      @expand(animate)
    else
      @collapse(animate)

  expand: (animate=false) ->
    if animate
      @matches.show 100, => @removeClass 'is-collapsed'
    else
      @matches.show()
      @removeClass 'is-collapsed'

  collapse: (animate=false) ->
    if animate
      @matches.hide 100, => @addClass 'is-collapsed'
    else
      @matches.hide()
      @addClass 'is-collapsed'

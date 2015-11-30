ProgressIndicator = ->
  restrict: 'E'
  replace: true
  scope:
    actual: '@'
    expected: '@'
    progressText: '@'
  controller: 'BwProgressController'
  templateUrl: 'app/templates/progress-indicator/progress-indicator.html'

ProgressArc = ->
  restrict: 'A'
  require: '^^bwProgressIndicator'
  scope:
    value: '@'
    type: '@'
    radiusOffset: '@'
  link: (scope, element, attrs, progressController) ->
    progressController.registerArc scope, element, attrs
    return

BwProgressController = ($scope, config) ->
  vm = @

  init = ()->
    vm.registerArc = registerArc
    vm.arcGen = arcGen
    vm.findArcColor = findArcColor
    vm.arcTween = arcTween
    vm.arcs = [ ]

  registerArc = (arc, element, attrs) ->
    arc.svgWidth = element[0].ownerSVGElement.getBoundingClientRect().width
    arc.svgHeight = element[0].ownerSVGElement.getBoundingClientRect().height
    arc.arcGen = arcGen(Math.min(arc.svgHeight, arc.svgWidth), parseFloat(arc.radiusOffset))
    @arcs.push arc

    # register methods for arc
    arc.redraw = ->
      # set arc type if applicable
      color = vm.findArcColor() if @type is "actual"
      newValue = parseFloat(@value) || 0
      newValue = 0 if newValue < 0
      endAngle = newValue * 2 * Math.PI

      # render the arc from 0
      path = d3.select(element[0])
        .attr 'transform', 'translate(' + @svgWidth / 2 + ',' + @svgHeight / 2 + ')'
        .datum endAngle: 0

      if newValue is 0
        path.attr 'd', '0'
      else
        path
        .transition()
        .duration 1500
        .call vm.arcTween, endAngle, @arcGen

      element.removeClass 'red orange green'
      element.addClass color
      return

    arc.$watch 'value', (newVal) ->
      if arc.type is "expected" then a.redraw() for a in vm.arcs \
      else arc.redraw()
      return

    return

  $scope.$watch 'actual', (newVal) ->
    actual = parseFloat($scope.actual) || 0
    actual = 0 if actual < 0
    if actual > 5 then $scope.percentText = ">500" else \
      $scope.percentText = (actual * 100).toFixed(0)
    return

  #ref: http://bl.ocks.org/mbostock/5100636
  arcTween = (transition, newAngle, a) ->
    transition.attrTween 'd', (d) ->
      interpolate = d3.interpolate(d.endAngle, newAngle)
      (t) ->
        d.endAngle = interpolate(t)
        a(d)
    return

  arcGen = (svgWidth, radiusOffset) ->
    d3.svg.arc()
      .innerRadius svgWidth * 0.35 + radiusOffset
      .outerRadius svgWidth * 0.35 + radiusOffset + config.arcThickness
      .startAngle 0

  findArcColor = () ->
    expected = Math.min(Math.max(parseFloat($scope.expected), 0), 1)
    actual = Math.min(Math.max(parseFloat($scope.actual), 0), 1);

    if expected > 0
      behind = (expected - actual) / expected

      if behind > config.danger
        return 'red'
      else if behind > config.warning
        return 'orange'
      else
        return 'green'

    'green'

  init()

  return

angular.module 'bw.components.progress-indicator', []
  .controller 'BwProgressController', BwProgressController
  .directive 'bwProgressIndicator', ProgressIndicator
  .directive 'bwProgressArc', ProgressArc
  .constant 'config',
    animate: true
    arcThickness: 5
    danger: 0.5
    warning: 0.25

BwProgressController.$inject = [
  '$scope'
  'config'
]

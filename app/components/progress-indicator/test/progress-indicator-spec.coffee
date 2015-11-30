describe 'progress-indicator controller', ->
  controller = {}
  scope = {}

  beforeEach module 'bw.components.progress-indicator'
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    controller = $controller 'BwProgressController',
      $scope: scope
      config:
        animate: true
        arcThickness: 5
        danger: 0.5
        warning: 0.25
    return
  )

  describe 'intialization', ->

    it 'should initialize correctly', ->
      expect(controller.arcs).toBeEmptyArray()
      expect(controller.registerArc).not.toBeUndefined()
      expect(controller.arcGen).not.toBeUndefined()
      expect(controller.findArcColor).not.toBeUndefined()
      expect(controller.arcTween).not.toBeUndefined()
      return

    return

  describe 'findArcColor', ->

    it 'should return "red" when actual is behind by >50% ', ->
      scope.expected = 0.9
      scope.actual = 0.3
      expect(controller.findArcColor()).toBe 'red'
      return

    it 'should return "orange" when actual is behind by 50%', ->
      scope.expected = 1.0
      scope.actual = 0.5
      expect(controller.findArcColor()).toBe 'orange'
      return

    it 'should return "orange" when actual is behind by >25% and <50%', ->
      scope.expected = 0.7
      scope.actual = 0.5
      expect(controller.findArcColor()).toBe 'orange'
      return

    it 'should return "green" when actual is behind by 25%', ->
      scope.expected = 1.0
      scope.actual = 0.75
      expect(controller.findArcColor()).toBe 'green'
      return

    it 'should return "green" when actual is <25% behind', ->
      scope.expected = 0.7
      scope.actual = 0.6
      expect(controller.findArcColor()).toBe 'green'
      return

    it 'should return "green" when actual is more than expected ', ->
      scope.expected = 0.7
      scope.actual = 0.9
      expect(controller.findArcColor()).toBe 'green'
      return

    it 'should return "green" when expected is 0 ', ->
      scope.expected = 0
      scope.actual = 0.1
      expect(controller.findArcColor()).toBe 'green'
      return

    return

  describe '$watch', ->

    it 'should be fired when actual value change', ->
      scope.actual = 0.75
      scope.$digest()
      expect(scope.percentText).toBe '75'
      return
    return

  describe 'arcGen', ->
    it 'should return arc generator', ->
      arcGen = controller.arcGen(150, 10)
      expect(arcGen.innerRadius()()).toBe 62.5
      expect(arcGen.outerRadius()()).toBe 67.5
      expect(arcGen.startAngle()()).toBe 0
      return
    return
  return

describe 'progress-indicator directive', ->
  element = {}

  beforeEach module 'bw.components.progress-indicator'
  beforeEach module 'templates'
  beforeEach inject(($compile, $rootScope) ->
    element = $compile('<div style="width:100px;height:100px"><bw-progress-indicator expected="0.5" actual="0.4"></bw-progress-indicator></div>')($rootScope)
    $rootScope.$digest()
    return
  )

  it 'should set up svg components correctly', ->
    expect(element).toContainElement 'svg'
    expect(element).toContainElement 'circle'
    expect(element.find('path').length).toBe 2
    expect(element.find('text').length).toBe 2
    expect(element.find('tspan').length).toBe 2
    return
  return

describe 'bw-progress-arc directive', ->
  bwProgressControllerMock = {}

  beforeEach module 'bw.components.progress-indicator'
  beforeEach ->
    bwProgressControllerMock = registerArc: (arc, element, attrs) ->
    spyOn bwProgressControllerMock, 'registerArc'
    element = angular.element '<fake-parent><path bw-progress-arc class="progress-path actual"></path></fake-parent>'
    element.data '$bwProgressIndicatorController', bwProgressControllerMock

    inject ($compile, $rootScope) ->
      $compile(element) $rootScope.$new()
      return

    element = element.find('path')
    return

  it 'should call registerArc method', ->
    expect(bwProgressControllerMock.registerArc).toHaveBeenCalled()
    return
  return

routes = require('../index.coffee')('ab3 bc4 cd5 ca6 ef7 gh8 hi9')

describe 'orgin to final destination routes', () ->
  it 'with max number of stops', () ->
    expect(routes.find_routes('a', 'c', 5).length).toEqual(2)

  it 'with exact number of stops', () ->
    expect(routes.find_routes_with_number_of_stops('a', 'c', 5).length).toEqual(1)

  it 'to the shortest route', () ->
    expect(routes.find_shortest_route('a','c').distance()).toEqual(7)

  it 'less than a certain distance', () ->
    expect(routes.find_routes_less_than('a', 'c', 21).length).toEqual(2)

describe 'all routes for an orgin', () ->
  it 'with only direct connections', () ->
    expect(routes.find_routes_from('e').length).toEqual(1)

  it 'with connections that cannot continue', () ->
    expect(routes.find_routes_from('g').length).toEqual(2)

  it 'with connections that can continue with maximum of 2 stops', () ->
    expect(routes.find_routes_from('a', 2).length).toEqual(2)

describe 'exact routes with no connections', () ->
  it 'finds exact route for ab', () ->
    expect(routes.find_exact_route('a', 'b').toString()).toEqual('ab3')

  it 'finds exact route for bc', () ->
    expect(routes.find_exact_route('b', 'c').toString()).toEqual('bc4')

  it 'returns NO SUCH ROUTE for non existent routs', () ->
    expect(routes.find_exact_route('a', 'c').toString()).toEqual('NO SUCH ROUTE')

describe 'exact routes with connections', () ->
  it 'finds exact route for bcd', () ->
    expect(routes.find_exact_route('b', 'c', 'd').toString()).toEqual('bcd9')

  it 'finds exact route for with duplicate station abca13', () ->
    expect(routes.find_exact_route('a', 'b', 'c', 'a').toString()).toEqual('abca13')

  it 'returns NO SUCH ROUTE for non existent routs', () ->
    expect(routes.find_exact_route('b', 'c', 'e').toString()).toEqual('NO SUCH ROUTE')

describe 'route', () ->
  describe 'with no connections', () ->
    it 'have an origin', () ->
      expect(routes.route('a').origin).toEqual('a')

    it 'have a destination', () ->
      expect(routes.route('a', 'b').destination).toEqual('b')

    it 'have a distance', () ->
      expect(routes.route('a', 'b', 6).distance()).toEqual(6)

    it 'display origin, destination and distance', () ->
      expect(routes.route('a','b',4).toString()).toEqual('ab4')

    it 'calculates the number of stops as 1', () ->
      expect(routes.route('a','b', 6).stops()).toEqual(1)

  describe 'with connection', () ->
    route1 = null
    route2 = null

    beforeEach () ->
      route1 = routes.route('a', 'b', 6)
      route2 = routes.route('b', 'c', 5)

    it 'calculate total distance', () ->
      expect(route1.connect_to(route2).distance()).toEqual(11)

    it 'displays origin, final destination and total distance', () ->
      expect(route1.connect_to(route2).toString()).toEqual('abc11')

    it 'calculates the number of stops', () ->
      route1.connect_to(route2)
      expect(route1.stops()).toEqual(2)

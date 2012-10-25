var routes = require('../index.js')('ab3 bc4');

describe('routes', function() {
  it('build routes', function() {
    var route = routes.find_exact_route('a', 'b');
    expect(route.toString()).toEqual('ab3');
  });
});

describe('route', function() {
  describe('with no connections', function() {
    it('have an origin', function() {
      var route = routes.route('a');
      expect(route.origin).toEqual('a');
    });

    it('have a destination', function() {
      var route = routes.route('a', 'b');
      expect(route.destination).toEqual('b');
    });

    it('have a distance', function() {
      var route = routes.route('a', 'b', 6);
      expect(route.distance()).toEqual(6);
    });

    it('display origin, destination and distance', function() {
      var route = routes.route('a','b',4);
      expect(route.toString()).toEqual('ab4');
    });
  });

  describe('with connection', function() {
    var route1, route2;

    beforeEach(function() {
      route1 = routes.route('a', 'b', 6);
      route2 = routes.route('b', 'c', 5);
    });

    it('calculate total distance', function() {
      expect(route1.connect_to(route2).distance()).toEqual(11);
    });

    it('displays origin, final destination and total distance', function() {
      expect(route1.connect_to(route2).toString()).toEqual('ac11');
    });
  });
});

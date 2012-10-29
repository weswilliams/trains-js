var routes = require('../index.js')('ab3 bc4 cd5');

describe('direct routes with no connections', function() {
  it('finds exact route for ab', function() {
    expect(routes.find_exact_route('a', 'b').toString()).toEqual('ab3');
  });

  it('finds exact route for bc', function() {
    expect(routes.find_exact_route('b', 'c').toString()).toEqual('bc4');
  });

  it('returns NO SUCH ROUTE for non existent routs', function() {
    expect(routes.find_exact_route('a', 'c').toString()).toEqual('NO SUCH ROUTE');
  });
});

describe('route', function() {
  describe('with no connections', function() {
    it('have an origin', function() {
      expect(routes.route('a').origin).toEqual('a');
    });

    it('have a destination', function() {
      expect(routes.route('a', 'b').destination).toEqual('b');
    });

    it('have a distance', function() {
      expect(routes.route('a', 'b', 6).distance()).toEqual(6);
    });

    it('display origin, destination and distance', function() {
      expect(routes.route('a','b',4).toString()).toEqual('ab4');
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

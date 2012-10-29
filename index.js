module.exports = function(routes_to_map) {
  var routes = [],
      cities = {};

  routes_to_map = routes_to_map || '';

  routes.find_exact_route = function(origin, destination) {
    var found = {
      toString: function() {
        return 'NO SUCH ROUTE';
      }
    };
    origin = cities[origin];
    destination = cities[destination];
    routes.forEach(function(route) {
      if (route.origin === origin && route.destination === destination) {
        found = route;
      }
    });
    return found;
  };

  routes.route = function(origin, destination, distance) {
    var route = {}, 
        connection = {};

    connection.distance = function() { return 0; };
    connection.final_destination = function() { return null; };

    route.origin = origin;
    route.destination = destination;

    route.distance = function() {
      return connection.distance() + distance;
    };

    route.connect_to = function(connecting_route) {
      connection = connecting_route;
      return route;
    };

    route.final_destination = function() {
      return connection.final_destination() || route.destination;
    };

    route.toString = function() {
      return route.origin.toString() + route.final_destination().toString() + route.distance().toString();
    };

    return route;
  };

  routes.city = function(name) {
    var found = cities[name];
    if (found === undefined) {
      found = city(name);
      cities[name] = found;
    }
    return found;
  };

  (function(routes_to_map) {
    var route_pattern = /[a-zA-Z]{2}\d/g;
    routes_to_map.match(route_pattern).forEach(function(route_str) {
      var origin = routes.city(route_str.charAt(0)),
          destination = routes.city(route_str.charAt(1)),
          distance = parseInt(route_str.charAt(2), 10);
      routes.push(routes.route(origin, destination, distance));
    });
  })(routes_to_map);

  return routes;
};

var city = function(name) {
  var city = {};
  city.name = name;
  city.toString = function() {
    return city.name;
  };
  return city;
};

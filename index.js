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
    var city = cities[name];
    if (name === undefined) {
      city = city(name);
      cities[name] = city;
    }
    return city;
  };

  (function(routes_to_map) {
    var route_pattern = /[a-zA-Z]{2}\d/g;
    routes_to_map.match(route_pattern).forEach(function(route_str) {
      routes.push( routes.route(route_str.charAt(0), route_str.charAt(1), parseInt(route_str.charAt(2), 10) ) );
    });
  })(routes_to_map);

  return routes;
};

var city = function(name) {
  var city = {};
  city.name = name;
  return city;
};

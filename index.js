module.exports = function(routes_to_map) {
  var routes = {},
      cities = {};
      no_route = {
        toString: function() {
          return 'NO SUCH ROUTE';
        }
      };

  routes_to_map = routes_to_map || '';

  routes.find_exact_route = function() {
    var args = Array.prototype.slice.call(arguments);
    var route_cities = args.map(function(name) {
      return routes.city(name);
    });
    origin = route_cities[0];
    return origin.exact_route_to(route_cities.slice(1)) || no_route;
  };

  routes.route = function(origin, destination, distance) {
    var route = {}, 
        connection = {};

    connection.distance = function() { return 0; };
    connection.origins = function() { return ''; };
    connection.final_destination = function() { return null; };
    connection.toString = function() { return 'end of the line'; };

    route.origin = origin;
    route.destination = destination;

    route.distance = function() {
      return connection.distance() + distance;
    };

    route.connect_to = function(connecting_route) {
      if (connecting_route !== null) {
        connection = connecting_route;
      }
      return route;
    };

    route.origins = function() {
      return route.origin.toString() + connection.origins();
    };

    route.final_destination = function() {
      return connection.final_destination() || route.destination;
    };

    route.toString = function() {
      return route.origins() + route.final_destination().toString() + route.distance().toString();
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

  var city = function(name) {
    var city = {}, 
        connections = {};

    city.name = name;

    city.add_connection = function(connection) {
      connections[connection.city] = connection;
    };

    city.toString = function() {
      return city.name;
    };

    city.exact_route_to = function(destinations) {
      var connection = connections[destinations[0]],
          route = null;
      if (connection !== undefined) {
        route = routes.route(city, connection.city, connection.distance);
        var remaining_destinations = destinations.slice(1);
        if (remaining_destinations.length > 0) {
          if (destinations[0].connects_to(destinations[1])) {
            route.connect_to(destinations[0].exact_route_to(remaining_destinations));
          } else {
            route = null;
          }
        }
      }
      return route;
    };

    city.connects_to = function(other_city) {
      return connections[other_city] !== undefined;
    };

    return city;
  };

  (function(routes_to_map) {
    var route_pattern = /[a-zA-Z]{2}\d/g;
    routes_to_map.match(route_pattern).forEach(function(route_str) {
      var origin = routes.city(route_str.charAt(0)),
          destination = routes.city(route_str.charAt(1)),
          distance = parseInt(route_str.charAt(2), 10);
      origin.add_connection({
        city: destination,
        distance: distance
      });
    });
  })(routes_to_map);

  return routes;
};

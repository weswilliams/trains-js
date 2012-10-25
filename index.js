module.exports = function() {
  var routes = {};
  routes.route = function(origin, destination, distance) {
    var route = {}, 
        connection = {};

    connection.distance = function() { return 0; };

    route.origin = origin;
    route.destination = destination;

    route.distance = function() {
      return connection.distance() + distance;
    };

    route.connect_to = function(connecting_route) {
      connection = connecting_route;
      return route;
    };

    route.toString = function() {
      return route.origin.toString() + route.destination.toString() + route.distance().toString();
    };

    return route;
  };
  return routes;
}();

module.exports = function() {
  var routes = {};
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
  return routes;
}();

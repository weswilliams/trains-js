module.exports = (routes_to_map) ->
  routes = {}
  cities = {}
  no_route =
    stops: () -> 0
    toString: () -> 'NO SUCH ROUTE'

  routes_to_map = routes_to_map or ''

  routes.find_routes = (origin, destination, max_stops) ->
    destination = routes.city destination
    routes.find_routes_from(origin, max_stops).filter (route) ->
      route.final_destination() is destination

  routes.find_routes_with_number_of_stops = (origin, destination, number_of_stops) ->
    routes.find_routes(origin, destination, number_of_stops).filter (route) ->
      route.stops() is number_of_stops

  routes.find_shortest_route = (origin, destination) ->
    long_distance_route = distance: () -> 999999
    shorter_route = (route1, route2) ->
      if route1.distance() < route2.distance() then route1 else route2
    routes.find_routes(origin, destination).reduce(shorter_route, long_distance_route)

  routes.find_routes_less_than = (origin, destination, max_distance) ->
    routes.find_routes(origin, destination).filter (route) ->
      route.distance() < max_distance

  routes.find_routes_from = (origin, max_stops) ->
    max_stops = max_stops or 10
    routes.city(origin).all_routes(max_stops)

  routes.find_exact_route = (args...) ->
    route_cities = args.map (name) ->
      routes.city(name)
    route_cities[0].exact_route_to(route_cities.slice(1)) or no_route

  routes.route = (origin, destination, distance) ->
    route = {}
    connection =
      stops: () -> 0
      distance: () -> 0
      origins: () -> ''
      final_destination: () -> null
      toString: () -> 'end of the line'

    route.origin = origin
    route.destination = destination

    route.stops = () -> 1 + connection.stops()

    route.distance = () -> connection.distance() + distance

    route.connect_to = (connecting_route) ->
      connection = connecting_route if connecting_route isnt null
      route

    route.origins = () -> route.origin.toString() + connection.origins()

    route.final_destination = () -> connection.final_destination() or route.destination

    route.toString = () ->
      route.origins() + route.final_destination().toString() + route.distance().toString()

    route

  routes.city = (name) -> cities[name] or cities[name] = build_city(name)

  build_city = (name) ->
    city = {}
    connections = {}

    city.name = name

    build_route = (origin, connection) -> routes.route origin, connection.city, connection.distance

    city.add_connection = (connection) -> connections[connection.city] = connection

    city.toString = () -> city.name

    city.all_routes = (max_stops, number_of_stops) ->
      max_stops = max_stops or 10
      number_of_stops = number_of_stops or 1
      return [] if number_of_stops > max_stops
      city.build_connecting_routes max_stops, number_of_stops + 1

    city.build_connecting_routes = (max_stops, number_of_stops) ->
      city_routes = []
      for name, connection of connections
        city_routes.push build_route(city, connection)
        connection.city.all_routes(max_stops, number_of_stops).forEach (connecting_route) ->
          city_routes.push build_route(city, connection).connect_to(connecting_route)
      city_routes

    city.exact_route_to = (destinations) ->
      connection = connections[destinations[0]]
      if (connection isnt undefined)
        route = build_route city, connection
        route = city.build_connection_to route, destinations.slice(1)
      route

    city.build_connection_to = (route, remaining_destinations) ->
      return route if remaining_destinations.length < 1
      if route.destination.connects_to(remaining_destinations[0])
        return route.connect_to(route.destination.exact_route_to(remaining_destinations))
      null

    city.connects_to = (other_city) -> return connections[other_city]?

    city

  ((routes_to_map) ->
    route_pattern = /[a-zA-Z]{2}\d/g
    routes_to_map.match(route_pattern).forEach (route_str) ->
      origin = routes.city route_str.charAt(0)
      destination = routes.city route_str.charAt(1)
      distance = parseInt route_str.charAt(2), 10
      origin.add_connection
        city: destination
        distance: distance
  )(routes_to_map)

  routes

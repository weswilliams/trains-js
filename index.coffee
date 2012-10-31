module.exports = (routes_to_map) ->
  routes = {}
  cities = {}
  no_route =
    stops: () -> return 0
    toString: () -> return 'NO SUCH ROUTE'

  routes_to_map = routes_to_map || ''

  routes.find_routes = (origin, destination, max_stops) ->
    destination = routes.city destination
    return routes.find_routes_from(origin, max_stops).filter (route) ->
      return route.final_destination() == destination

  routes.find_routes_with_number_of_stops = (origin, destination, number_of_stops) ->
    return routes.find_routes(origin, destination, number_of_stops).filter((route) ->
      return route.stops() == number_of_stops
    )

  routes.find_shortest_route = (origin, destination) ->
    long_distance_route =
      distance: () -> return 999999
    shorter_route = (route1, route2) ->
      if route1.distance() < route2.distance()
        return route1
      return route2
    return routes.find_routes(origin, destination).reduce(shorter_route, long_distance_route)

  routes.find_routes_less_than = (origin, destination, max_distance) ->
    return routes.find_routes(origin, destination).filter((route) ->
      return route.distance() < max_distance
    )

  routes.find_routes_from = (origin, max_stops) ->
    max_stops = max_stops || 10
    return routes.city(origin).all_routes(max_stops)

  routes.find_exact_route = (args...) ->
    route_cities = args.map((name) ->
      return routes.city(name)
    )
    origin = route_cities[0]
    return origin.exact_route_to(route_cities.slice(1)) || no_route

  routes.route = (origin, destination, distance) ->
    route = {}
    connection = {}

    connection.stops = () -> return 0
    connection.distance = () -> return 0
    connection.origins = () -> return ''
    connection.final_destination = () -> return null
    connection.toString = () -> return 'end of the line'

    route.origin = origin
    route.destination = destination

    route.stops = () ->
      return 1 + connection.stops()

    route.distance = () ->
      return connection.distance() + distance

    route.connect_to = (connecting_route) ->
      if (connecting_route != null)
        connection = connecting_route
      return route

    route.origins = () ->
      return route.origin.toString() + connection.origins()

    route.final_destination = () ->
      return connection.final_destination() || route.destination

    route.toString = () ->
      return route.origins() + route.final_destination().toString() + route.distance().toString()

    return route

  routes.city = (name) ->
    found = cities[name]
    if (found == undefined)
      found = build_city(name)
      cities[name] = found
    return found

  build_city = (name) ->
    city = {}
    connections = {}

    city.name = name

    build_route = (origin, connection) ->
      return routes.route(origin, connection.city, connection.distance)

    city.add_connection = (connection) ->
      connections[connection.city] = connection

    city.toString = () ->
      return city.name

    city.all_routes = (max_stops, number_of_stops) ->
      max_stops = max_stops || 10
      number_of_stops = number_of_stops || 1
      if number_of_stops > max_stops
        return []
      return city.build_connecting_routes(max_stops, number_of_stops + 1)

    city.build_connecting_routes = (max_stops, number_of_stops) ->
      found = []
      for name, connection of connections
        found.push(build_route(city, connection))
        connection.city.all_routes(max_stops, number_of_stops).forEach((connecting_route) ->
          found.push(build_route(city, connection).connect_to(connecting_route))
        )
      return found

    city.exact_route_to = (destinations) ->
      connection = connections[destinations[0]]
      route = null
      if (connection != undefined)
        route = build_route(city, connection)
        route = city.build_connection_to(route, destinations.slice(1))
      return route

    city.build_connection_to = (route, remaining_destinations) ->
      if remaining_destinations.length < 1
        return route
      if route.destination.connects_to(remaining_destinations[0])
        return route.connect_to(route.destination.exact_route_to(remaining_destinations))
      return null

    city.connects_to = (other_city) ->
      return connections[other_city] != undefined

    return city

  ((routes_to_map) ->
    route_pattern = /[a-zA-Z]{2}\d/g
    routes_to_map.match(route_pattern).forEach((route_str) ->
      origin = routes.city(route_str.charAt(0))
      destination = routes.city(route_str.charAt(1))
      distance = parseInt(route_str.charAt(2), 10)
      origin.add_connection(
        city: destination
        distance: distance
      )
    )
  )(routes_to_map)

  return routes
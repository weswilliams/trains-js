var routes = require('./index.js')('AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7');

// 1. The distance of the route A-B-C.
//Output #1: 9
console.log('Output #1: ' + routes.find_exact_route('A','B','C').distance());

// 2. The distance of the route A-D.
//Output #2: 5
console.log('Output #2: ' + routes.find_exact_route('A','D').distance());

// 3. The distance of the route A-D-C.
//Output #3: 13
console.log('Output #3: ' + routes.find_exact_route('A','D','C').distance());

// 4. The distance of the route A-E-B-C-D.
//Output #4: 22
console.log('Output #4: ' + routes.find_exact_route('A','E','B','C','D').distance());

// 5. The distance of the route A-E-D.
//Output #5: NO SUCH ROUTE
console.log('Output #5: ' + routes.find_exact_route('A','E','D'));

// 6. The number of trips starting at C and ending at C with a maximum of 3 stops.  In the sample data below, there are two such trips: C-D-C (2 stops). and C-E-B-C (3 stops).
//Output #6: 2
console.log('Output #6: ' + routes.find_routes('C','C',3).length);

// 7. The number of trips starting at A and ending at C with exactly 4 stops.  In the sample data below, there are three such trips: A to C (via B,C,D); A to C (via D,C,D); and A to C (via D,E,B).
//Output #7: 3

// 8. The length of the shortest route (in terms of distance to travel) from A to C.
//Output #8: 9

// 9. The length of the shortest route (in terms of distance to travel) from B to B.
//Output #9: 9

// 10. The number of different routes from C to C with a distance of less than 30.  In the sample data, the trips are: CDC, CEBC, CEBCDC, CDCEBC, CDEBC, CEBCEBC, CEBCEBCEBC.
//Output #10: 7


SQLFiddle URL : http://sqlfiddle.com/#!2/2095f/327/6


Schema:

CREATE TABLE data (n varchar(9), l varchar(10));


Queries :

SET @G = PointFromText('POINT(1 1)');

SET @P= PolygonFromText('POLYGON((0 0,3 0,0 3,0 0))');


SELECT GeometryType(@P) AS Query1;

SELECT Within(@G,@P) AS QUERY2;

SELECT Contains(@P,@G) AS Query3;

SELECT AsText(Envelope(@P)) AS Query4;

SELECT AsText(Centroid(@P)) AS Query5;
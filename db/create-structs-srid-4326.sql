-- A table of points
CREATE TABLE points (
    id SERIAL PRIMARY KEY,
    pt PCPOINT(1)
);

-- A table of patches
CREATE TABLE patches (
    id SERIAL PRIMARY KEY,
    pa PCPATCH(1)
);


CREATE OR REPLACE FUNCTION public.getpcloud( quantos integer, xmin double precision, ymin double precision, xmax double precision, ymax double precision)
RETURNS json as
$func$   
select row_to_json(fc)
from (
    select
        'FeatureCollection' as "type",
        array_to_json(array_agg(f)) as "features"
    from (
        select
            'Feature' as "type",
            ST_AsGeoJSON(ST_Transform( pt::geometry, 4326), 6) :: json as "geometry",
            (  select json_strip_nulls(row_to_json(t)) from ( select 'Attr1' as attr1,'Attr2' as attr2 ) t  ) as "properties"
        from points
        where public.points.pt::geometry && ST_MakeEnvelope($2, $3, $4, $5, 4326)
        limit $1
    ) as f
) as fc;
$func$ LANGUAGE sql STABLE STRICT;


-- FROM OFICIAL REPOSITORY EXAMPLE
INSERT INTO pointcloud_formats (pcid, srid, schema) VALUES (1, 4326,
'<?xml version="1.0" encoding="UTF-8"?>
<pc:PointCloudSchema xmlns:pc="http://pointcloud.org/schemas/PC/1.1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <pc:dimension>
    <pc:position>1</pc:position>
    <pc:size>4</pc:size>
    <pc:description>X coordinate as a long integer. You must use the
                    scale and offset information of the header to
                    determine the double value.</pc:description>
    <pc:name>X</pc:name>
    <pc:interpretation>int32_t</pc:interpretation>
    <pc:scale>0.01</pc:scale>
  </pc:dimension>
  <pc:dimension>
    <pc:position>2</pc:position>
    <pc:size>4</pc:size>
    <pc:description>Y coordinate as a long integer. You must use the
                    scale and offset information of the header to
                    determine the double value.</pc:description>
    <pc:name>Y</pc:name>
    <pc:interpretation>int32_t</pc:interpretation>
    <pc:scale>0.01</pc:scale>
  </pc:dimension>
  <pc:dimension>
    <pc:position>3</pc:position>
    <pc:size>4</pc:size>
    <pc:description>Z coordinate as a long integer. You must use the
                    scale and offset information of the header to
                    determine the double value.</pc:description>
    <pc:name>Z</pc:name>
    <pc:interpretation>int32_t</pc:interpretation>
    <pc:scale>0.01</pc:scale>
  </pc:dimension>
  <pc:dimension>
    <pc:position>4</pc:position>
    <pc:size>2</pc:size>
    <pc:description>The intensity value is the integer representation
                    of the pulse return magnitude. This value is optional
                    and system specific. However, it should always be
                    included if available.</pc:description>
    <pc:name>Intensity</pc:name>
    <pc:interpretation>uint16_t</pc:interpretation>
    <pc:scale>1</pc:scale>
  </pc:dimension>
  <pc:metadata>
    <Metadata name="compression">dimensional</Metadata>
  </pc:metadata>
</pc:PointCloudSchema>');



-- POTREE SCHEMA SCALE 001
INSERT INTO pointcloud_formats (pcid, srid, schema) VALUES (3, 4326,
'<?xml version="1.0" encoding="UTF-8"?>
<pc:PointCloudSchema xmlns:pc="http://pointcloud.org/schemas/PC/1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <pc:dimension>
  <pc:position>1</pc:position>
  <pc:size>4</pc:size>
  <pc:description>X coordinate</pc:description>
  <pc:name>X</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.01</pc:scale>
  <pc:offset>!XOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>2</pc:position>
  <pc:size>4</pc:size>
  <pc:description>Y coordinate</pc:description>
  <pc:name>Y</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.01</pc:scale>
  <pc:offset>!YOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>3</pc:position>
  <pc:size>4</pc:size>
  <pc:description>Z coordinate</pc:description>
  <pc:name>Z</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.01</pc:scale>
  <pc:offset>!ZOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>4</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Representation of the pulse return magnitude</pc:description>
  <pc:name>Intensity</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
   <pc:position>5</pc:position>
   <pc:size>1</pc:size>
   <pc:description>ASPRS classification.  0 for no classification.</pc:description>
   <pc:name>Classification</pc:name>
   <pc:interpretation>uint8_t</pc:interpretation>
   <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>6</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Red image channel value</pc:description>
  <pc:name>Red</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>7</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Green image channel value</pc:description>
  <pc:name>Green</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>8</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Blue image channel value</pc:description>
  <pc:name>Blue</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:metadata>
<Metadata name="compression" type="string"/>none</pc:metadata>
 <pc:orientation>point</pc:orientation>
</pc:PointCloudSchema>');

--POTREE SCHEMA SCALE 01
INSERT INTO pointcloud_formats (pcid, srid, schema) VALUES (2, 4326,
'<?xml version="1.0" encoding="UTF-8"?>
<pc:PointCloudSchema xmlns:pc="http://pointcloud.org/schemas/PC/1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <pc:dimension>
  <pc:position>1</pc:position>
  <pc:size>4</pc:size>
  <pc:description>X coordinate</pc:description>
  <pc:name>X</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.1</pc:scale>
  <pc:offset>!XOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>2</pc:position>
  <pc:size>4</pc:size>
  <pc:description>Y coordinate</pc:description>
  <pc:name>Y</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.1</pc:scale>
  <pc:offset>!YOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>3</pc:position>
  <pc:size>4</pc:size>
  <pc:description>Z coordinate</pc:description>
  <pc:name>Z</pc:name>
  <pc:interpretation>int32_t</pc:interpretation>
  <pc:scale>0.1</pc:scale>
  <pc:offset>!ZOFFSET!</pc:offset>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>4</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Representation of the pulse return magnitude</pc:description>
  <pc:name>Intensity</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
   <pc:position>5</pc:position>
   <pc:size>1</pc:size>
   <pc:description>ASPRS classification.  0 for no classification.</pc:description>
   <pc:name>Classification</pc:name>
   <pc:interpretation>uint8_t</pc:interpretation>
   <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>6</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Red image channel value</pc:description>
  <pc:name>Red</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>7</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Green image channel value</pc:description>
  <pc:name>Green</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:dimension>
  <pc:position>8</pc:position>
  <pc:size>2</pc:size>
  <pc:description>Blue image channel value</pc:description>
  <pc:name>Blue</pc:name>
  <pc:interpretation>uint16_t</pc:interpretation>
  <pc:active>true</pc:active>
 </pc:dimension>
 <pc:metadata>
<Metadata name="compression" type="string"/>none</pc:metadata>
 <pc:orientation>point</pc:orientation>
</pc:PointCloudSchema>');




### ToDo:
## dymaxion proj. track and map (include equirec2dymaxion)


- load raster in qgis
- georeference raster:
https://docs.qgis.org/2.2/en/docs/user_manual/plugins/plugins_georeferencer.html
http://gis.stackexchange.com/questions/28881/convert-an-arbitrary-meta-data-free-map-image-into-qgis-project

- convert XML to GPX: http://www.gpsvisualizer.com/
- load GPX as vector in qgis
- connect points to lines with Point2One plugin: http://gis.stackexchange.com/questions/898/convert-xy-points-to-a-line#899
- make waypoint labels only show up on hover: http://gis.stackexchange.com/questions/86130/label-features-on-hover-click-with-qgis
- export raster and overlays as SVG (not tested yet): http://gis.stackexchange.com/questions/61198/drawing-on-jpg-map-image-with-proj4-perl#61201


all : track_on_map.pdf


%.png :
#	wget http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73655/$@
	wget  ftp://ftp.cscs.ch/out/stockli/bluemarble/bmng/$@

%.jpgw :
	wget ftp://ftp.cscs.ch/out/stockli/bluemarble/bmng/bmng_arcview/$@

world_500m_%.pngw : world.topo.bathy.200404.3x21600x21600.%.pngw
	ln -s $< $@

track_wget.shp : track_wget.gpx

track_on_map.qgs : track_wget.gpx track_wget.shp \
		world.topo.bathy.200404.3x21600x21600.B1.png world.topo.bathy.200404.3x21600x21600.B1.pngw \
		world.topo.bathy.200404.3x21600x21600.C1.png world.topo.bathy.200404.3x21600x21600.C1.pngw

track_on_map.qgs :
	qgis $<

track_on_map.pdf : track_on_map.qgs
	shp2img ||| qgis --snapshot --project $< # http://gis.stackexchange.com/questions/61198/drawing-on-jpg-map-image-with-proj4-perl#61201


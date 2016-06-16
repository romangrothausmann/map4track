
### ToDo:
## dymaxion proj. track and map (include equirec2dymaxion)


# - load raster in qgis
# - georeference raster:
# https://docs.qgis.org/2.2/en/docs/user_manual/plugins/plugins_georeferencer.html
# http://gis.stackexchange.com/questions/28881/convert-an-arbitrary-meta-data-free-map-image-into-qgis-project

# - load GPX as vector in qgis
# { - connect points to lines with Point2One plugin: http://gis.stackexchange.com/questions/898/convert-xy-points-to-a-line#899 } not needed any more with track2gpx.xsl
# - make waypoint labels only show up on hover: http://gis.stackexchange.com/questions/86130/label-features-on-hover-click-with-qgis
# - export raster and overlays as SVG (not tested yet): http://gis.stackexchange.com/questions/61198/drawing-on-jpg-map-image-with-proj4-perl#61201


all : track_on_map.pdf


%.png :
	wget http://eoimages.gsfc.nasa.gov/images/imagerecords/73000/73655/$@
#	wget ftp://ftp.cscs.ch/out/stockli/bluemarble/bmng/$@ # only withouth bathymetry

%.jpgw :
	wget ftp://ftp.cscs.ch/out/stockli/bluemarble/bmng/bmng_arcview/$@

world.topo.bathy.200404.3x21600x21600.%.pngw : world_500m_%.jpgw
	ln -s $< $@

track_wget.xml : # examplary AIS track, cookie probably expired
	wget 'www.marinetraffic.com/map/gettrackxml/shipid:283459/mmsi:247817000/stdate:2016-03-29%2022:58/endate:2016-04-15%2022:58' \
		--referer='http://www.marinetraffic.com/'  \
		--save-cookies cookies.wget  \
		--no-cookies \
		--header 'Cookie: SERVERID=www5; _ga=GA1.2.1818160876.1461165859; CAKEPHP=k47c6tgnakr1bga4a9k8l68hn3; mp_mixpanel__c=146; __atuvc=3%7C16; __gads=ID=1e178216d27e8e1f:T=1461166106:S=ALNI_MYL7BMf_s7POiqB8pPziO7BCjbfMA; vTo=1; _gat=1; mp_338b03007448c81d380c96b13da8b83a_mixpanel=%7B%22distinct_id%22%3A%20%2215434495a02131-0ed235e17805208-3d6a4640-140000-15434495a0383%22%2C%22%24search_engine%22%3A%20%22google%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fwww.google.de%2Furl%3Fsa%3Dt%26rct%3Dj%26q%3D%26esrc%3Ds%26source%3Dweb%26cd%3D3%26cad%3Drja%26uact%3D8%26ved%3D0ahUKEwj9h-7hw53MAhVEVxQKHfkMBsEQFggsMAI%26url%3Dhttps%253A%252F%252Fwww.marinetraffic.com%252Fen%252Fais%252Fdetails%252Fships%252F308693000%26usg%3DAFQjCNECNNsCIcahQXN7pgsXVq1qSmINEg%26bvm%3Dbv.119745492%2Cd.bGs%22%2C%22%24initial_referring_domain%22%3A%20%22www.google.de%22%7D' \
		-U 'Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0'
		-O $@

track_wget.gpx : track_wget.xml
	xsltproc code/track2gpx.xsl $< > $@  # or use: http://www.gpsvisualizer.com/

track_wget.shp : track_wget.gpx

%.png : %.pngw

track_on_map.qgs : world.topo.bathy.200404.3x21600x21600.B1.png	world.topo.bathy.200404.3x21600x21600.C1.png \
		track_wget.gpx # should be last to be on top of PNGs
	qgis $^

track_on_map.pdf : track_on_map.qgs
	shp2img ||| qgis --snapshot --project $< # http://gis.stackexchange.com/questions/61198/drawing-on-jpg-map-image-with-proj4-perl#61201

.SECONDARY:

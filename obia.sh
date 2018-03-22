#!/bin/sh
export GISBASE=/usr/lib/grass72
export GRASS_VERSION=72

#echo -n "Enter extension directory (i.e /usr/lib/grass70/grass-addons):"
#read EXT_ADDONS
#sudo mkdir $EXT_ADDONS
#export GRASS_ADDON_BASE=$EXT_ADDONS
#echo -n "Enter username and group (i.e user:user):"
#read userng
#sudo chown -R $userng $EXT_ADDONS
#sudo chmod u=rwx $EXT_ADDONS
#export GRASS_ADDON_BASE=$EXT_ADDONS

#generate GISRCRC
MYGISDBASE=/home/user/working/GISDATA/GrassDirecotry/
MYLOC=Thesis
MYMAPSET=user

# Set the global grassrc file to individual file name
MYGISRC="$HOME/.grassrc.$GRASS_VERSION.$$"

echo "GISDBASE: $MYGISDBASE" > "$MYGISRC"
echo "LOCATION_NAME: $MYLOC" >> "$MYGISRC"
echo "MAPSET: $MYMAPSET" >> "$MYGISRC"
echo "GRASS_GUI: text" >> "$MYGISRC"

# path to GRASS settings file
export GISRC=$MYGISRC
export GRASS_PYTHON=python
export GRASS_MESSAGE_FORMAT=plain
export GRASS_TRUECOLOR=TRUE
export GRASS_TRANSPARENT=TRUE
export GRASS_PNG_AUTO_WRITE=TRUE
export GRASS_GNUPLOT='gnuplot -persist'
export GRASS_WIDTH=640
export GRASS_HEIGHT=480
export GRASS_HTML_BROWSER=firefox
export GRASS_PAGER=cat
export GRASS_WISH=wish

export PATH="$GISBASE/bin:$GISBASE/scripts:$PATH"
export LD_LIBRARY_PATH="$GISBASE/lib"
export GRASS_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PYTHONPATH="$GISBASE/etc/python:$PYTHONPATH"
export MANPATH=$MANPATH:$GISBASE/man

#For the temporal modules
export TGISDB_DRIVER=sqlite
export TGISDB_DATABASE=$MYGISDBASE/$MYLOC/PERMANENT/tgis/sqlite.db

# =============== START WORKING ================================

# Import Raster Data
#r.import input=/home/user/Desktop/Gera_sentinel2.tif output=Gera_sentinel2 --overwrite
#r.import input=/home/user/Desktop/data/Gera_sentinel2.img output=gera2 --overwrite

# Import Vector Data
#v.import -o input=/home/user/Desktop/train/corine_lesvos_2100.shp output=corine_train2 encoding=UTF-8 --overwrite
#v.import -o input=/home/user/Desktop/new_train/new_training.shp output=train_gera encoding=UTF-8 --overwrite

# Set the region of my working directory to this raster
g.region rast=gera2.1 save=region --overwrite
#Create Group
i.group  group=OBIAgera subgroup=gera input=gera2.1,gera2.2,gera2.3

i.group  group=OBIAath subgroup=athens input=athens.1,athens.2,athens.3


#Set variables for loop
CATS_gera="$(v.db.select -c map=corine_train2 columns=cat)"
step_athens=""
step_gera=""
CATS_athens="$(v.db.select -c map=train_athens columns=cat)"

#Create a loop so we can add multiple layers in to our USPO region
for i in $CATS_gera
do
where="cat=$i"
regionname="subset_uspo_gera_corine_$i"
v.extract --overwrite input=corine_train2 type=area where=$where output=$regionname
g.region --overwrite vector=$regionname save=region_uspo_gera_corine_$i
step_gera=$step_gera"region_uspo_gera_corine_$i,"

i.segment.uspo --overwrite group=OBIAgera output=/home/user/Desktop/resaults/obiatest_gera_$i.csv segment_map=best_gera_$i region=region_uspo_gera_corine_$i threshold_start=0.601 threshold_stop=0.901 threshold_step=0.001 minsizes=8 memory=4000 processes=4

r.to.vect --overwrite input=best_gera_"$i"_region_uspo_gera_corine_"$i"_rank1 output=temp_best_gera_corine_$i type=area

v.out.ogr --overwrite input=temp_best_gera_$i type=area output=/home/user/Desktop/resaults/res_gera_corine_$i.shp

done

regions_uspo_gera=${step_gera%,}
echo $regions_uspo_gera
#i.segment.uspo --overwrite group=OBIAgera output=/home/user/Desktop/resaults/obiatest_gera.csv segment_map=best_gera region=$regions_uspo_gera threshold_start=0.601 threshold_stop=0.901 threshold_step=0.001 minsizes=8 memory=4000 processes=4

#r.to.vect --overwrite input=best_gera_regions_uspo_g_rank1@user output=temp_best_gera type=area
#v.out.ogr --overwrite input=temp_best_gera type=area output=/home/user/Desktop/resaults/res_gera.shp

#for i in $CATS_athens
#do
#where="cat=$i"
#regionname="subset_uspo_athens_$i"
#v.extract --overwrite input=train_athens@user type=area where=$where output=region_uspo_athens_$i
#step_athens=$step_athens"region_uspo_athens_$i,"
#g.region --overwrite vector=region_uspo_athens_$i save=region_athens$i align=athens.1@user -u
#step_athens=$step_athens"region_uspo_athens_$i,"
#done
#regions_uspo_ath=${step_athens%,}


#g.region --overwrite vector=$regions_uspo_gera save=regions_uspo_g

#install extension (svn required)
#sudo apt-get install
#subversion

#install Grass development package
#sudo apt-get install grass-dev

#----------------------------------------------------------------------------
#in case there is an error about a file that can not be downloaded (i.e /var/cache/apt/archives/grass-dev_7.0.5-1~xenial1_amd64.deb)
#----------------------------------------------------------------------------
#sudo dpkg -i --force-overwrite /var/cache/apt/archives/grass-dev_7.0.5-1~xenial1_amd64.deb

#g.extension -s extension=i.segment.uspo operation=add
#g.extension -s extension=i.segment.hierarchical operation=add
#g.extension -s extension=r.neighborhoodmatrix operation=add

#Segmentation using USPO
#i.segment.uspo --overwrite group=OBIA2 output=/home/user/Desktop/resaults/obiatest1.csv segment_map=best1 region=regions_uspo threshold_start=0.001 threshold_stop=0.301 threshold_step=0.001 minsizes=8 memory=2000 processes=4

#####i.segment.uspo --overwrite group=OBIA2 output=/home/user/Desktop/resaults/obiatest2.csv segment_map=best2 region=regions_uspo threshold_start=0.301 threshold_stop=0.601 threshold_step=0.001 minsizes=8 memory=2000 processes=4

####i.segment.uspo --overwrite group=OBIAgera output=/home/user/Desktop/resaults/obiatest_gera.csv segment_map=best_gera region=$regions_uspo_gera threshold_start=0.601 threshold_stop=0.901 threshold_step=0.001 minsizes=8 memory=4000 processes=4


#g.region rast=athens.1 save=region --overwrite
#g.region --overwrite vector=$regions_uspo_athens save=regions_uspo_a

#i.segment.uspo --overwrite group=OBIAath output=/home/user/Desktop/resaults/obiatest_athens.csv segment_map=best_athens region=regions_uspo_a threshold_start=0.601 threshold_stop=0.901 threshold_step=0.001 minsizes=8 memory=4000 processes=4

#for cities
#i.segment.uspo --overwrite group=OBIA2@user output=cities regions=region_1@user segmentation_method=region_growing threshold_start=0.601 threshold_stop=0.901 threshold_step=0.001 minsizes=8 memory=2000 processes=4

#Export segmentation as vector and remove that vector
#r.to.vect --overwrite input=best1_2_regions_uspo_rank1@user output=temp_best1_2 type=area
#r.to.vect --overwrite input=best2_2_regions_uspo_rank1@user output=temp_best2_2 type=area
##r.to.vect --overwrite input=best3_2_regions_uspo_rank1@user output=temp_best3_2 type=area

#v.out.ogr --overwrite input=temp_best1_2 type=area output=/home/user/Desktop/resaults/res1_2.shp
#v.out.ogr --overwrite input=temp_best2_2 type=area output=/home/user/Desktop/resaults/res2_2.shp
##v.out.ogr --overwrite input=temp_best3_2 type=area output=/home/user/Desktop/resaults/res3_2.shp
#format=ESRI_Shapefile

#g.remove -r -f type=vector pattern=temp_best_vect
#v.import -o input=/home/user/Desktop/resaults/res3_2.shp output=res3_2 encoding=UTF-8 --overwrite
#Compute total area to be segmented for process progression information
#pt="$(v.db.select -c map=res3_2 columns=cat)"
#for i in $pt
#do
#where2="cat=$i"
#tempvector="temp_polygon_$i"
#v.extract --overwrite input=res3_2 type=area where=$where2 output=temp_polygon_$i
#g.region --overwrite vector=$tempvector, align=gera2.1
#r.mask --overwrite vector=tempvector
#outputsegment="segmentation_tile_$i"
#optimized_threshold=
#i.segment --overwrite group=OBIA2 output=$outputsegment threshold=$optimized_threshold minsize=8 #memory=2000
#done

#R jobs
#start R
#R

#quit R

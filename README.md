# Object based image analysis (OBIA) using a shellscript with GRASS commands

OBIA is a Remote Sensing method where the machine "cuts" down the image into multiple shapes and then, based on the shape, the classication method and the number of classies it calassifiies the image. With this script you will be able to do just that.


### Prerequisites

Beforehand you will need a Linux machine with Ubuntu and installed GRASS GIS and Ubuntugis tools to be installed. You will
find the installation commands in the provided script.

### Installing

So, first things first, if you have a Linux machine but not the rest of prerequisites you will need to run the following commands

For the UbuntuGIS and GRASS GIS:
```
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
```
In case it didn't work execute:

```
sudo apt-get upgrade
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
```

## Built With

* [GRASS GIS](https://grass.osgeo.org/) - The GIS framework
* [Ubuntu](https://www.ubuntu.com/) - OS userd
* [Shellscript](https://www.shellscript.sh/) - A source of shell script tutorials


## Authors

* **KarlesP** - *Initial work* - [KarlesP](https://github.com/KarlesP)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* The main idea for this code came from Grippa T. et al and their paper "An Open-Source Semi-Automated Processing Chain for Urban Object-Based Classification" which you can find [HERE](https://www.researchgate.net/publication/315897308_An_Open-Source_Semi-Automated_Processing_Chain_for_Urban_Object-Based_Classification)

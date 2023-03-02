# **A small, simple and useful tool collection for Yocto**

**_NOTE_**

1. We assume that these scripts will be run from within your Yocto
workspace; in effect, from the `TOPDIR` or `BUILDDIR` directory, after you've correctly sourced the `oe-init-build-env` script.

2. Most of these helper tools require that:
the '*buildhistory*' feature turned on (to get required bitbake vars).
To do so, insert this line into your `conf/local.conf` file:

    INHERIT += "buildhistory"

3. The system has been built via bitbake (at least once)
4. Here's the way the scripts work in the presence of multiple items where, typically, only one is expected; for example, the MACHINE type, or target image or libc type. They will pick up just one - the latest one currently in use.


***The tools/helper scripts currently available are:***

- `burn4rpi_sd.sh`        : 'burn' script wrapper for the Raspberry Pi (media: uSD card in
                         regular laptop SDcard reader)
- `burn4rpi_usbsd.sh`     : 'burn' script wrapper for the Raspberry Pi (media: USB card reader)

- `common`                : Contains common vars and a few utility functions (not to be run directly).

It's useful setup_env() function, called by most of the scripts, displays the following (a sample):

    [--- WRT your current Yocto workspace/build config:
BUILDDIR = .../poky/build_qemuarm64

MACHINE  = qemuarm64

IMAGE    = core-image-base

TESTDATA_JSON file = <...>/poky/build_qemuarm64/tmp/deploy/images/qemuarm64/core-image-base-qemuarm64.testdata.json

---]

- `disp_all_build_images` : simple script that shows all possible build targets
                        for bitbake (eg. core-image-minimal     : it's location)

- `host_setup_4yocto`     : helper script to setup an Ubuntu host system for Yocto

- **`info_yocto`            : one of the most useful!** 
    - It displays setup info, followed by a few `DISTRO` variable values, number of packages, total size. Further, if you pass the option switch:
    - `-l` : it displays *all Layers and their recipes*
    - `-x` : eXtended format: show names of *all recipes under each layer/recipe*
        - Only works if passed in addition to `-l`, i.e., run as:

              `info_yocto -lx`

    - `-h`   : show this Help screen


- `lookup_recipe.sh`      : queries and prints for each package in the current build,
                          \{package-name          : recipe-that-generates-it\}

- `query_toaster`         : queries health of Toaster web-gui and displays some details if it's running

- `recipe_section_vals`   : shows all possible values for the `SECTION="xxx"` portion of a bitbake recipe

- `showvars`              : given a recipe name, shows several bitbake variables and their current value
                        (for that recipe. It finds the bb variables within the file
						`$WORKDIR/run.do_<foo>`, for all lines beginning with `export`)

- `showvars2`             : enhanced ver of previous script; shows several bitbake variables and
					    their current value.
                        Can pass multiple variable names as parameters (space separated); it will
						attempt to query and display their value(s)

- `Readme.md`            : this file

- `wic_wrsdcard.sh`     : (We're assuming the image is to be written to an (u)SD card mmcblk0)
                        It genertaes the WIC image(s) (auto-detecting the image type (eg. core-image-base) and the machine value; if sucessful, it attempts to write it out

- **`yct_recipe_gen`        : Useful!** A simple yocto 'recipe generator' script; as of now, very simplistic; might nevertheless prove a bit useful (of course, Yocto provides the full-fledged `recipetool` util).

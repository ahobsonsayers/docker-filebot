# Docker container for FileBot

This is a Docker container for FileBot. Much of the work came from jlesage's excellent filebot image but this image ustilises Guacamole due to its advantages. 

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client. 

**Guacamole** is used for GUI access in this fork. This is different to jlesage's image, and means the viewer will be more performant.

**This container uses FileBot version 4.7.9 as this is the last free version available.** 
**While the container will be updated, the FileBot version will not be.**

---

[![FileBot logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/filebot-icon.png&w=200)](http://www.filebot.net/)[![FileBot](https://dummyimage.com/400x110/ffffff/575757&text=FileBot)](http://www.filebot.net/)

FileBot is the ultimate tool for organizing and renaming your movies, tv shows
or anime, and music well as downloading subtitles and artwork. It's smart and
just works.

---

## Table of Content

   * [Docker container for FileBot](#docker-container-for-filebot)
      * [Table of Content](#table-of-content)
      * [Quick Start](#quick-start)
      * [Usage](#usage)
         * [Environment Variables](#environment-variables)
         * [Data Volumes](#data-volumes)
         * [Ports](#ports)
         * [Changing Parameters of a Running Container](#changing-parameters-of-a-running-container)
      * [Docker Image Update](#docker-image-update)
      * [User/Group IDs](#usergroup-ids)
      * [Accessing the GUI](#accessing-the-gui)
      * [Shell Access](#shell-access)
      * [Support or Contact](#support-or-contact)

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the FileBot docker container with the following command:
```
docker run -d \
    --name=filebot \
    -p 8080:8080 \
    -v /docker/appdata/filebot:/config \
    -v $HOME:/storage \
    arranhs/filebot
```

Where:
  - `/docker/appdata/filebot`: This is where the application stores its configuration, log and any files needing persistency.
  - `$HOME`: This location contains files from your host that need to be accessible by the application.

Browse to `http://your-host-ip:8080` to access the FileBot GUI.
Files from the host appear under the `/storage` folder in the container.

## Usage

```
docker run [-d] \
    --name=filebot \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-v <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    arranhs/filebot
```
| Parameter | Description                                                                                                                                               |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -d        | Run the container in background.  If not set, the container runs in foreground.                                                                           |
| -e        | Pass an environment variable to the container.  See the [Environment Variables](#environment-variables) section for more details.                         |
| -v        | Set a volume mapping (allows to share a folder/file between the host and the container).  See the [Data Volumes](#data-volumes) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host).  See the [Ports](#ports) section for more details.                           |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable | Description                                                                                                                  | Default         |
| -------- | ---------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `UID`    | ID of the user the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set.  | `1000`          |
| `GID`    | ID of the group the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000`          |
| `TZ`     | [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container.       | `Europe/London` |

### Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path | Permissions | Description                                                                                    |
| -------------- | ----------- | ---------------------------------------------------------------------------------------------- |
| `/config`      | rw          | This is where the application stores its configuration, log and any files needing persistency. |
| `/storage`     | rw          | This location contains files from your host that need to be accessible by the application.     |

### Ports

Here is the list of ports used by the container.  They can be mapped to the host
via the `-p` parameter (one per port mapping).  Each mapping is defined in the
following format: `<HOST_PORT>:<CONTAINER_PORT>`.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description                                                                                         |
| ---- | --------------- | --------------------------------------------------------------------------------------------------- |
| 8080 | Mandatory       | Port used to access the application's GUI via the web interface.                                    |
| 3389 | Optional        | Port used to access the application's GUI via the VNC protocol.  Optional if no VNC client is used. |

### Changing Parameters of a Running Container

As seen, environment variables, volume mappings and port mappings are specified
while creating the container.

The following steps describe the method used to add, remove or update
parameter(s) of an existing container.  The generic idea is to destroy and
re-create the container:

  1. Stop the container (if it is running):
```
docker stop filebot
```
  2. Remove the container:
```
docker rm filebot
```
  3. Create/start the container using the `docker run` command, by adjusting
     parameters as needed.

**NOTE**: Since all application's data is saved under the `/config` container
folder, destroying and re-creating a container is not a problem: nothing is lost
and the application comes back with the same state (as long as the mapping of
the `/config` folder remains the same).

## Docker Image Update

If the system on which the container runs doesn't provide a way to easily update
the Docker image, the following steps can be followed:

  1. Fetch the latest image:
```
docker pull arranhs/filebot
```
  2. Stop the container:
```
docker stop filebot
```
  3. Remove the container:
```
docker rm filebot
```
  4. Start the container using the `docker run` command.

## User/Group IDs

When using data volumes (`-v` flags), permissions issues can occur between the
host and the container.  For example, the user within the container may not
exists on the host.  This could prevent the host from properly accessing files
and folders on the shared volume.

To avoid any problem, you can specify the user the application should run as.

This is done by passing the user ID and group ID to the container via the
`UID` and `GID` environment variables.

To find the right IDs to use, issue the following command on the host, with the
user owning the data volume on the host:

    id <username>

Which gives an output like this one:
```
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),4(adm),24(cdrom),27(sudo),46(plugdev),113(lpadmin)
```

The value of `uid` (user ID) and `gid` (group ID) are the ones that you should
be given the container.

## Accessing the GUI

Assuming that container's ports are mapped to the same host's ports, the
graphical interface of the application can be accessed via:

  * A web browser:
```
http://<HOST IP ADDR>:8080
```

  * Any VNC client:
```
<HOST IP ADDR>:3389
```
## Shell Access

To get shell access to a the running container, execute the following command:

```
docker exec -ti CONTAINER sh
```

Where `CONTAINER` is the ID or the name of the container used during its
creation (e.g. `filebot`).

## Reverse Proxy

The following sections contains NGINX configuration that need to be added in
order to reverse proxy to this container.

A reverse proxy server can route HTTP requests based on the hostname or the URL
path.

[TimeZone]: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

[create a new issue]: https://github.com/ahobsonsayers/docker-filebot/issues

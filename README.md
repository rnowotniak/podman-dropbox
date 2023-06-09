# Dropbox CLI in Podman rootless

Contact: Robert Nowotniak <rnowotniak@metasolid.tech>

If you don't want to run a proprietary and closed-source Dropbox CLI directly on your host machine,
you can use this project, to run Dropbox in a podman container.

## Build the image
```
$ git clone https://github.com/rnowotniak/podman-dropbox.git
$ cd podman-dropbox

$ podman build -t dbox .
(...)

$ podman images
REPOSITORY      TAG         IMAGE ID      CREATED      SIZE
localhost/dbox  latest      9e20bf2a248b  2 hours ago  269 MB
$ _
```

## Run the container
```
DROPBOX_DIR=/mnt/wdext/Dropbox-podman    # it will contain Drobox installation, and Dropbox/ subdir with your files
DROPBOX_HOSTNAME=podman-dbox             # you will see this in your linked devices list in Drobox security panel

podman run --hostname=$DROPBOX_HOSTNAME --name dbox -d -v $DROPBOX_DIR:/root dbox
```

## Check the Dropbox log
```
$ podman logs -f dbox
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/cryptography.hazmat.bindings._openssl.abi3.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/cryptography.hazmat.bindings._padding.abi3.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/apex._apex.abi3.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/psutil._psutil_linux.cpython-38-x86_64-linux-gnu.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/psutil._psutil_posix.cpython-38-x86_64-linux-gnu.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/tornado.speedups.cpython-38-x86_64-linux-gnu.so'
dropbox: load fq extension '/root/.dropbox-dist/dropbox-lnx.x86_64-170.4.5895/wrapt._wrappers.cpython-38-x86_64-linux-gnu.so'
This computer isn't linked to any Dropbox account...
Please visit https://www.dropbox.com/cli_link_nonce?nonce=c95fedc977d7fbe5c079e9da28e75dbd to link this device.
This computer isn't linked to any Dropbox account...
Please visit https://www.dropbox.com/cli_link_nonce?nonce=c95fedc977d7fbe5c079e9da28e75dbd to link this device.
This computer isn't linked to any Dropbox account...
(...)
```

Open the link from the log, to link this container device to your Dropbox account.

```
$ podman logs -f dbox
(...)
This computer is now linked to Dropbox. Welcome Robert
```

## Check Dropbox status
```
$ podman exec dbox dropbox.py status
Syncing 139,954 files • 58 mins
Downloading 139,954 files (0.0 KB/sec, 58 mins)
$ _

(...)

$ podman exec dbox dropbox.py status
Up to date
$ _

(...)

$ du -sch $DROPBOX_DIR/Dropbox/
718M	/mnt/wdext/Dropbox-podman/Dropbox/
$ _
```

## (Optional) Sync files selectively
Add all '*' to the exclude list, remove selected directories from the exclude list
```
$ cd $DROPBOX_DIR
$ podman exec -it dbox dropbox.py exclude add Dropbox/*           # exclude all
$ podman exec -it dbox dropbox.py exclude remove Dropbox/tmp      # sync selectively, remove dir from the exclude list
$ podman exec -it dbox dropbox.py exclude remove Dropbox/Photos   # sync selectively, remove dir from the exclude list
```

## Notes

Include in the image:
1. dropbox.tgz  -- download during the image build, and incorporate in the container przezimage
1. dropbox.py   -- should be in the image

When the container is launched:
1. ~/.dropbox-dist  - will be installed when the container is launched, from dropbox.tgz
2. start ~/.dropbox-dist/dropboxd

When Dropbox daemon is started:
1. ~/.dropbox (state, settings, exclude etc)  -  per container, created when dropbox is started
1. ~/Dropbox (files) -  db installer tries to recreate it - per container, created when dropbox is started


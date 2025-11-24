Download the latest Ubuntu installer from https://www.netacad.com/resources/lab-downloads.

Move the installer to this directory and name it `CiscoPacketTracer.deb`

Consume the package from other flakes like this:
```nix
inputs = {
  cisco-packet-tracer = {
    url = "path:${pathToFlake}/packages/cisco-packet-tracer";
    inputs.cisco-packet-tracer-deb.url = "path:${pathToFlake}/packages/cisco-packet-tracer/CiscoPacketTracer.deb";
  };
}
```
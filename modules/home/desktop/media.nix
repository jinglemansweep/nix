# Media: Kodi with PVR addon and NFS media sources
{ config, pkgs, lib, ... }:

{
  home.packages = [
    (pkgs.kodi.withPackages (kodiPkgs: [
      kodiPkgs.pvr-iptvsimple
    ]))
  ];

  home.file.".kodi/userdata/sources.xml".text = ''
    <sources>
      <video>
        <source>
          <name>Movies</name>
          <path>/mnt/nfs/media/movies/</path>
        </source>
        <source>
          <name>TV Shows</name>
          <path>/mnt/nfs/media/tv/</path>
        </source>
      </video>
      <music>
        <source>
          <name>Music</name>
          <path>/mnt/nfs/media/music/</path>
        </source>
      </music>
    </sources>
  '';
}

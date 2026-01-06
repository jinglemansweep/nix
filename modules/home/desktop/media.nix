{ config, pkgs, lib, ... }:

{
  home.packages = [
    # Media center with PVR addon
    (pkgs.kodi.withPackages (kodiPkgs: [
      kodiPkgs.pvr-iptvsimple
    ]))

    # Video players
    pkgs.vlc
    pkgs.mpv

    # Media tools
    pkgs.ffmpeg
  ];

  # Kodi media sources configuration
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

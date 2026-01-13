{ config, pkgs, lib, ... }:

{
  # VLC, mpv, ffmpeg installed at NixOS level for all users

  home.packages = [
    # Media center with PVR addon (has user-specific config below)
    (pkgs.kodi.withPackages (kodiPkgs: [
      kodiPkgs.pvr-iptvsimple
    ]))
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

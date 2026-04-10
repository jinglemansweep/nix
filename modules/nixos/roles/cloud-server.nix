# Cloud server role: firewall, QEMU guest agent
{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 51820 ];
  };
  services.qemuGuest.enable = true;
}

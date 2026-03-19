# Cloud server role: firewall, QEMU guest agent
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.qemuGuest.enable = true;
}

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :carprs, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"
node_name = if Mix.env() != :prod, do: "carprs"

# config :xgps, port_to_start: {"ttyAMA0"}
config :xgps, port_to_start: {"cu.usbserial-310"}

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    networks: [
      [
        ssid: System.get_env("NERVES_NETWORK_SSID"),
        psk: System.get_env("NERVES_NETWORK_PSK"),
        key_mgmt: String.to_atom(key_mgmt),
        # if your WiFi setup as hidden
        scan_ssid: 1
      ]
    ]
  ],
  wlan0: [
    ipv4_address_method: :dhcp
  ]

if Mix.target() != :host do
  import_config "target.exs"
end

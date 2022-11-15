import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dungeon_and_dragons, DungeonAndDragonsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7lOU5PfSwZvlK9LYAdvn61J1CBY/mqpi7se9xt9+K58jAyt3w8AXtJTWqkMs4/+z",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

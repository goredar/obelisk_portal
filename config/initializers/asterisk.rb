p File.expand_path('config/asterisk.yml', Rails.root)
ASTERISK_CONFIG = YAML.load_file(Rails.root.join('config/asterisk.yml'))[Rails.env]
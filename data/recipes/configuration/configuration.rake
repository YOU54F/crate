#
# The recipe for integrating configuration into the ruby build
#
Crate::GemIntegration.new("configuration", "0.0.5") do |t|
  t.upstream_source  = "https://rubygems.org/downloads/configuration-0.0.5.gem"
  t.upstream_sha1    = "ae65a38666706959aaaa034fb7cb3d0234349ecc"
end

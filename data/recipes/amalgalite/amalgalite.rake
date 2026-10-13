#
# The recipe for integrating amalgalite into the ruby build
#
Crate::GemIntegration.new("amalgalite", "1.9.4") do |t|
  t.upstream_source = "https://rubygems.org/downloads/amalgalite-1.9.4.gem"
  #t.upstream_sha1   = "84a84fd1192cef2d77701ec74afc8325a2a99ca7"
end

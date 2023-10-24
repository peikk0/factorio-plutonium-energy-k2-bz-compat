function set_radioactivity()
  remote.call("kr-radioactivity", "add_item", "MOX-fuel")
  remote.call("kr-radioactivity", "add_item", "breeder-fuel-cell")
  remote.call("kr-radioactivity", "add_item", "plutonium-238")
  remote.call("kr-radioactivity", "add_item", "plutonium-239")
  remote.call("kr-radioactivity", "add_item", "plutonium-fuel")
  remote.call("kr-radioactivity", "add_item", "used-up-MOX-fuel")
  remote.call("kr-radioactivity", "add_item", "used-up-breeder-fuel-cell")
  remote.call("kr-radioactivity", "add_item", "used-up-breeder-fuel-cell-solution-barrel")
  remote.call("kr-radioactivity", "add_item", "used-up-uranium-fuel-cell-solution-barrel")
end

script.on_init(set_radioactivity)
script.on_configuration_changed(set_radioactivity)

NetherMachine.listener.register("PLAYER_LOGIN", function(...)
  NetherMachine.print('Player login detected, NetherMachine initializing!')
  NetherMachine.rotation.auto_unregister()
  NetherMachine.listener.trigger("PLAYER_SPECIALIZATION_CHANGED", "player")
  NetherMachine.listener.trigger("ACTIONBAR_SLOT_CHANGED", "player")
  NetherMachine.interface.init()
  NetherMachine.module.player.init()
  NetherMachine.raid.build()
end)

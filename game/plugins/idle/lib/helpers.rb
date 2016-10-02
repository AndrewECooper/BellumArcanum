module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor.has_any_role?(Global.read_config("idle", "roles", "can_idle_sweep"))
    end

    def self.is_exempt?(actor)
      actor.has_any_role?(Global.read_config("idle", "roles", "idle_exempt"))
    end
        
    def self.active_chars
      base_list = Character.find(idled_out: nil).union(idled_out: false)
      base_list.select { |c| !(Roles::Api.is_admin?(c) || c.is_playerbit || Login::Api.is_guest?(c))}
    end
    
  end
end
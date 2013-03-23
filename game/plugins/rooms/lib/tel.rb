module AresMUSH
  module Rooms
    class Tel
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("tel")
      end
      
      def on_command(client, cmd)
        dest = cmd.args
        room = Room.find_one_and_notify(dest, client)
        return if room.nil?
        
        client.emit_success("You teleport to #{room["name"]}.")
        client.player["location"] = room["_id"]
        Player.update(client.player)
        client.emit Describe.format_room_desc(room)
      end
    end
  end
end
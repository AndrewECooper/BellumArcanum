module AresMUSH
  module Api
    class MasterRegisterCmdHandler < ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiRegisterCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        if (game_id != ServerInfo.default_game_id)
          return cmd.create_error_response("Game has already been registered.")
        end
       
        key = ApiCrypt.generate_key
        game_id = ServerInfo.next_id

        Global.logger.info "Creating new game #{args.name}."

        game = ServerInfo.create(name: args.name, 
          category: args.category, 
          description: args.desc,
          host: args.host,
          port: args.port,
          key: key,
          game_id: game_id)
          
        response_args = ApiRegisterResponseArgs.new(game_id, key)
        cmd.create_response(ApiResponse.ok_status, response_args.to_s)
      end
    end
  end
end
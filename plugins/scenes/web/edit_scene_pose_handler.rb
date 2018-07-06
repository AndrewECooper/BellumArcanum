module AresMUSH
  module Scenes
    class EditScenePoseRequestHandler
      def handle(request)
        scene = Scene[request.args[:scene_id]]
        scene_pose = ScenePose[request.args[:pose_id]]
        pose_text = request.args[:pose]
        enactor = request.enactor
        
        if (!scene || !scene_pose)
          return { error: t('webportal.not_found') }
        end
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!Scenes.can_access_scene?(enactor, scene))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!scene_pose.can_edit?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        scene_pose.update(pose: pose_text)
        message = t('scenes.edited_scene_pose', :name => enactor.name, :pose => pose_text)
        
        if (scene.room)
          scene.room.emit_ooc message
        end
          
        Scenes.add_to_scene(scene, WebHelpers.format_markdown_for_html(message), Game.master.system_character, is_setpose = false, is_ooc = true)
        
        { pose: WebHelpers.format_markdown_for_html(pose_text) }
      end
    end
  end
end
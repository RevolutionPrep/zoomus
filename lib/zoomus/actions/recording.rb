module Zoomus
  module Actions
    module Recording

      def recording_list(*args)
        options = Utils.extract_options!(args)
        Utils.require_params(:host_id, options)
        Utils.process_datetime_params!(:from, options)
        Utils.process_datetime_params!(:to, options)
        Utils.parse_response self.class.post("/recording/list", :query => options)
      end

      def recording_get(*args)
        options = Utils.extract_options!(args)
        Utils.require_params(:meeting_id, options)
        Utils.parse_response self.class.post("/recording/get", :query => options)
      end

      Utils.define_bang_methods(self)

    end
  end
end


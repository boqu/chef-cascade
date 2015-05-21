require 'chef/handler'
require 'cascade'
require 'hashie'

class Chef
  class Handler
    class CascadeHandler < Chef::Handler
      def report
        event = Hashie::Mash.new(
          name: 'cascade.cm,
          source: run_status.node.name,
          ref: Chef::Config[:ref_id]
        )

        if !run_status.kind_of?(Chef::RunStatus) or elapsed_time.nil?
          event.msg = 'start'

          ::Cascade::Event.fire(event)

          return
        end

        if run_status.failed?
          event.msg = 'fail'

          ::Cascade::Event.fire(event)
        end

        if run_status.success?
          event.msg = 'success'

          ::Cascade::Event.fire(event)
        end
      end
    end
  end
end

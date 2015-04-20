require 'chef/handler'
require 'cascade'
require 'hashie'

class Chef
  class Handler
    class CascadeHandler < Chef::Handler
      def report
        event = Hashie::Mash.new
        event.name = 'cascade.cm'
        event.source = run_status.node.name

        if !run_status.kind_of?(Chef::RunStatus) or elapsed_time.nil?
          event.status = 'start'

          ::Cascade::Event.fire(event)

          return
        end

        if run_status.failed?
          event.status = 'fail'

          ::Cascade::Event.fire(event)
        end

        if run_status.success?
          event.status = 'success'

          ::Cascade::Event.fire(event)
        end
      end
    end
  end
end

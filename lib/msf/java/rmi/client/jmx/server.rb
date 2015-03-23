# -*- coding: binary -*-

module Msf
  module Java
    module Rmi
      module Client
        module Registry
          require 'msf/java/rmi/client/jmx/server/builder'
          require 'msf/java/rmi/client/jmx/server/parser'

          include Msf::Java::Rmi::Client::Jmx::Server::Builder
          include Msf::Java::Rmi::Client::Jmx::Server::Parser

          # Sends a Registry lookup call to the RMI endpoint
          #
          # @param opts [Hash]
          # @option opts [Rex::Socket::Tcp] :sock
          # @return [Hash, NilClass] The remote reference information if success, nil otherwise
          # @see Msf::Java::Rmi::Client::Registry::Builder.build_registry_lookup
          def send_new_client(opts = {})
            send_call(
              sock: opts[:sock] || sock,
              call: build_jmx_new_client(opts)
            )

            return_value = recv_return(
              sock: opts[:sock] || sock
            )

            if return_value.nil?
              return nil
            end

            if return_value.is_exception?
              raise ::Rex::Proto::Rmi::Exception, return_value.get_class_name
            end

            ref = parse_jmx_new_client(return_value)

            ref
          end
        end
      end
    end
  end
end

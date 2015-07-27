require 'socket'
require_relative 'shell'

class Rosh
  # Object that represents a computer that Rosh commands are sent to. It's
  # really mostly a container for getting at the functionality of each of Rosh's
  # subsystems for that host.
  class Host
    # @param [String] host_name
    # @return [Boolean]
    def self.local?(host_name)
      %W[localhost #{Socket.gethostname}].include? host_name
    end

    # @!attribute [r] name
    #   The host name (aka hostname)
    #   @return [String]
    attr_reader :name

    # @!attribute [r] shell
    #   The Rosh::Shell object that's used by this object for running
    #   (some/many/most) commands.
    #   @return [Rosh::Shell]
    attr_reader :shell

    # Set to +true+ to tell the command to check the
    # state of the object its working on before working on it.  For
    # example, when enabled and running a command to create a user "joe"
    # will check to see if "joe" exists before creating it.  Defaults to
    # +false+.
    # @!attribute [w] idempotent_mode
    attr_writer :idempotent_mode

    # @param [String] host_name
    # @param [Hash] ssh_options that get passed along to the associated
    #   {{Rosh::Shell}} for when the Host is remote.
    def initialize(host_name, **ssh_options)
      @name = host_name
      @idempotent_mode = false
      @local = nil
    end

    # @return [Boolean] Returns if commands are set to check the state of
    #   host objects to determine if the command needs to be run.
    def idempotent_mode?
      @idempotent_mode
    end

    # @return [Boolean]
    def local?
      @local ||= self.class(@host_name)
    end
  end
end

require 'forwardable'
require_relative 'rosh/environment'

# Contains methods for configuring and checking config.
class Rosh
  @environment ||= Rosh::Environment.new

  class << self
    extend Forwardable

    # @!attribute [r] environment
    #   @return [Rosh::Environment]
    attr_reader :environment

    # @!attribute [r] hosts
    #   The currently managed Rosh::Hosts.
    #   @see Rosh::Environment#hosts
    def_delegator :@environment, :hosts

    # @!method add_host
    #   Adds a {{Rosh::Host}} to the +environment+.
    #   @see Rosh::Environment#add_host
    def_delegator :@environment, :add_host

    def reset!
      @environment = Rosh::Environment.new
    end
  end
end

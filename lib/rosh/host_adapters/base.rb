class Rosh
  module HostAdapters
    class Base
      class << self
        # @return [Symbol]
        def operating_system(shell)
          result = shell.exec('uname -a')
          log "STDOUT: #{result}"

          /^(?<os>[a-zA-Z]+) (?<uname>[^\n]*)/ =~ result.strip

          os.to_safe_down_sym
        end

        private

        # Extracts info about the operating system based on uname info.
        #
        # @param [Rosh::CommandResult] result The result of the `uname -a`
        #   command.
        def extract_os_info(result)

          kernel_info = case operating_system
                        when :darwin then Darwin.kernel_info
                        when :linux then Linux.kernel_info
                        when :freebsd then FreeBSD.kernel_info
                        end

          [operating_system] + kernel_info
        end
      end

      DISTRIBUTION_METHODS = %i[distribution distribution_version]

      DISTRIBUTION_METHODS.each do |meth|
        define_method(meth) do
          distro, version = extract_distribution

          @distribution = distro
          @distribution_version = version.strip

          instance_variable_get("@#{meth}".to_sym)
        end
      end

      def initialize(host_name, **ssh_options)
        @shell = Rosh::Shell.new(host_name, ssh_options)
        @kernel_version = nil
        @architecture = nil

        @distribution = nil
        @distribution_version = nil
      end

      # @return [Symbol]
      def operating_system
        return @operating_system if @operating_system

        command = 'uname -a'
        result = @shell.exec(command)
        extract_os(result)

        @operating_system
      end

      # @return [String]
      def kernel_version
        command = 'uname -a'
        result = @shell.exec(command)
        extract_os(result)

        @kernel_version
      end

      # @return [Symbol]
      def architecture
        return @architecture if @architecture

        command = 'uname -a'
        result = @shell.exec(command)
        extract_os(result)

        @architecture
      end

      # The name of the remote shell for the user on host_name that initiated the
      # Rosh::SSH connection for the host.
      #
      # @return [String] The shell type.
      def remote_shell
        command = 'echo $SHELL'
        result = @shell.exec(command)
        stdout = result.stdout
        log "STDOUT: #{stdout}"
        /(?<shell>[a-z]+)$/ =~ stdout

        shell.to_sym
      end

      def darwin?
        operating_system == :darwin
      end

      def linux?
        operating_system == :linux
      end

      #---------------------------------------------------------------------------
      # Privates
      #---------------------------------------------------------------------------

      private
    end
  end
end

class Rosh
  module HostAdapters
    class Linux < Base
      class << self
        def kernel_info
          /\S+\s+(?<kernel_version>\S+).*\s(?<arch>(x86_64|i386|i586|i686)).*$/ =~ uname

          [kernel_version, arch.downcase.to_sym]
        end
      end

      # Extracts info about the distribution.
      def extract_linux_distribution
        distro, version = catch(:distro_info) do
          stdout = @shell.exec('lsb_release --description')
          /Description:\s+(?<distro>\w+)\s+(?<version>[^\n]+)/ =~ stdout
          throw(:distro_info, [distro, version]) if distro && version

          stdout = @shell.exec('cat /etc/redhat-release')
          /(?<distro>\w+)\s+release\s+(?<version>[^\n]+)/ =~ stdout
          throw(:distro_info, [distro, version]) if distro && version

          stdout = @shell.exec('cat /etc/slackware-release')
          /(?<distro>\w+)\s+release\s+(?<version>[^\n]+)/ =~ stdout
          throw(:distro_info, [distro, version]) if distro && version

          stdout = @shell.exec('cat /etc/gentoo-release')
          /(?<distro>\S+).+release\s+(?<version>[^\n]+)/ =~ stdout
          throw(:distro_info, [distro, version]) if distro && version
        end

        [distro.to_safe_down_sym, version]
      end
    end
  end
end

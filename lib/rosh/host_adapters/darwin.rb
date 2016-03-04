class Rosh
  module HostAdapters
    class Darwin < Base
      class << self
        def kernel_info
          /Kernel Version (?<kernel_version>\d\d\.\d\d?\.\d\d?).*RELEASE_(?<arch>\S+)/ =~ uname

          [kernel_version, arch.downcase.to_sym]
        end
      end

      def extract_distribution
        stdout = @shell.exec 'sw_vers'
        /ProductName:\s+(?<distro>[^\n]+)\s*ProductVersion:\s+(?<version>\S+)/m =~ stdout

        [distro.to_safe_down_sym, version]
      end
    end
  end
end

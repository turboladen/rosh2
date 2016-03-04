class Rosh
  module HostAdapters
    class FreeBSD < Base
      class << self
        def kernel_info
          /\S+\s+(?<kernel_version>\S+).*\s(?<arch>\S+)\s*$/ =~ uname

          [kernel_version, arch.downcase.to_sym]
        end
      end
    end
  end
end

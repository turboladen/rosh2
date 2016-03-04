class Rosh
  class Shell
    def self.run(host_name, command, **ssh_options)
      shell = new(host_name, **ssh_options)

      result = shell.exec(command)

      yield result if block_given?
    end

    def initialize(host_name, **ssh_options)
      @host_name = host_name
      @ssh_options = ssh_options
      @history = []
      @sudo = false
      @internal_pwd = nil
      @workspace = nil
    end
  end
end

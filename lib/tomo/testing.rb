require "tomo"

module Tomo
  module Testing
    autoload :Connection, "tomo/testing/connection"
    autoload :DockerImage, "tomo/testing/docker_image"
    autoload :DockerPluginTester, "tomo/testing/docker_plugin_tester"
    autoload :HostExtensions, "tomo/testing/host_extensions"
    autoload :MockedExecError, "tomo/testing/mocked_exec_error"
    autoload :MockPluginTester, "tomo/testing/mock_plugin_tester"
    autoload :PluginTester, "tomo/testing/plugin_tester"
    autoload :SSHExtensions, "tomo/testing/ssh_extensions"

    class << self
      attr_reader :ssh_enabled

      def enabling_ssh
        orig_ssh = ssh_enabled
        @ssh_enabled = true
        yield
      ensure
        @ssh_enabled = orig_ssh
      end
    end
    @ssh_enabled = false
  end
end

Tomo.logger = Tomo::Logger.new(
  stdout: File.open(File::NULL, "w"), stderr: File.open(File::NULL, "w")
)
Tomo::Colors.enabled = false
Tomo::Host.prepend Tomo::Testing::HostExtensions
class << Tomo::SSH
  prepend Tomo::Testing::SSHExtensions
end

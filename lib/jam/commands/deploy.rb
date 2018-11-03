module Jam
  module Commands
    class Deploy
      def parser
        Jam::CLI::Parser.new do |parser|
          parser.banner = <<~BANNER
            Usage: jam deploy [options]

            Run the "deploy" script specified in .jam/project.json to deploy this project.
            For projects that have more than one environment (e.g. staging, production),
            specify the target environment using the `-e` option.
          BANNER
          parser.permit_empty_args = true
          parser.add(Jam::CLI::DeployOptions)
        end
      end

      def call(options)
        jam = Framework.new
        release = Time.now.utc.strftime("%Y%m%d%H%M%S")
        project = jam.load_project!(
          environment: options[:environment],
          settings: options[:settings].merge(
            release_path: "%<releases_path>/#{release}"
          )
        )
        jam.connect(project["host"]) do
          project["deploy"].each do |task|
            jam.invoke_task(task)
          end
        end
      end
    end
  end
end
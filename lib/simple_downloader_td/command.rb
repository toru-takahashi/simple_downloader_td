# coding: utf-8
require 'simple_downloader_td'
STDOUT.sync = true

module SimpleDownloaderTd
  class Command
    def initialize(argv)
      if (argv.size != 1) || (argv[0].to_i == 0)
        STDOUT.puts "usage: SimpleDownloaderTd <job id>"
        exit
      end
      @argv = argv
    end

    def self.run(argv)
      new(argv).execute
    end

    def execute
      SimpleDownloaderTd.download(@argv[0])
    end
  end
end

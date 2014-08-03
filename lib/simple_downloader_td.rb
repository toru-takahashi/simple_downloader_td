# coding: utf-8
require 'rubygems'
require "simple_downloader_td/version"
require "simple_downloader_td/command"
require 'msgpack'
require 'csv'
require 'json'
require 'td'
require 'td-client'
require 'zlib'
require 'fileutils'

module SimpleDownloaderTd
  def self.download(job_id)
    # Get TD APIKEY in ~/.td/td.conf
    data = File.read(File.join(ENV['HOME'], '.td', 'td.conf'))
    data.each_line do |line|
      line.strip!
      case line
      when /^#/
        next
      when /\[(.+)\]/
        section = $~[1]
      when /^(\w+)\s*=\s*(.+?)\s*$/
        key = $~[1]
        val = $~[2]
        @APIKEY = val
      else
        STDOUT.puts "Can't read apikey."
      end
    end
    cln = TreasureData::Client.new(@APIKEY, {ssl: true})

    # get job result
    job = cln.job(job_id)

    # check job status
    unless job.finished? then
      STDOUT.puts "The job didn't finish yet."
      exit
    end

    # download job result as msgpack.gz
    begin
      File.open("#{job_id}_tmp.msgpack.gz", "wb") do |f|
        job.result_format('msgpack.gz', f) do |compr_size|
          STDOUT.puts "Downloaded: #{(compr_size / job.result_size) * 100}%" if downloaded != (compr_size / job.result_size)
          downloaded = compr_size / job.result_size
        end
      end
    rescue Exception => e
      STDERR.puts e
    end
    STDOUT.puts "Start converting..."
    # convert tsv file
    begin
      File.open("#{job_id}.tsv", "w+") do |writer|
        src = MessagePack::Unpacker.new(Zlib::GzipReader.open("#{job_id}_tmp.msgpack.gz"))
        job.hive_result_schema.each do |schema|
          writer << schema[0] + "\t"
        end
        writer << "\n"
        src.each do |obj|
          writer << obj.join("\t") + "\n"
        end
      end
      File.delete("#{job_id}_tmp.msgpack.gz")
      STDOUT.puts "Finish."
    rescue Exception => e
      STDERR.puts e
    end
  end
end

require 'fileutils'
require 'open_uri_redirections'
require 'openssl'
require 'zip'

# Runs a sketch and reloads it when related files change
module SketchRunner
  def self.setup
    puts "Processing.rb #{VERSION}"

    return if File.exist?(APPDATA_CHECK_FILE) &&
              File.stat(APPDATA_CHECK_FILE).mtime > CONFIG_MTIME

    FileUtils.remove_dir(APPDATA_ROOT, true)

    puts 'JRuby and Processing will be downloaded just one time.'
    puts 'Please input a proxy if necessary, otherwise just press Enter.'
    print '(e.g. http://proxy.hostname:port): '
    proxy = $stdin.gets.chomp
    proxy = nil if proxy == ''

    download(JRUBY_URL, JRUBY_FILE, proxy)

    download(PROCESSING_URL, PROCESSING_ZIP_FILE, proxy)
    unzip(PROCESSING_ZIP_FILE, PROCESSING_ZIP_DIR)

    FileUtils.mkdir_p(PROCESSING_DIR)
    processing_core_dir = File.join(PROCESSING_ZIP_DIR, PROCESSING_CORE_PATH)
    FileUtils.cp_r(processing_core_dir, PROCESSING_DIR)

    processing_libs_dir = File.join(PROCESSING_ZIP_DIR, PROCESSING_LIBS_PATH)
    Dir.glob(File.join(processing_libs_dir, '*')).each do |dir|
      FileUtils.cp_r(dir, PROCESSING_DIR)
    end

    FileUtils.remove_dir(PROCESSING_ZIP_DIR, true)

    FileUtils.touch(APPDATA_CHECK_FILE)
  end
  private_class_method :setup

  def self.download(url, file, proxy)
    print "download #{File.basename(url)} ... "

    FileUtils.mkdir_p(File.dirname(file))

    open(file, 'wb') do |output|
      begin
        open(
          url,
          proxy: proxy,
          allow_redirections: :safe,
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
        ) do |data|
          output.write(data.read)
        end
      rescue StandardError
        puts "\nunable to download file -- #{url}"
        exit false
      end
    end

    puts 'done'
  end
  private_class_method :download

  def self.unzip(file, dest_dir)
    print "unzip #{File.basename(file)} ... "

    Zip::File.open(file) do |zip|
      zip.each do |entry|
        dest_file = File.join(dest_dir, entry.name)

        unless File.basename(dest_file).start_with?('._')
          entry.extract(dest_file)
        end
      end
    end

    puts 'done'
  end
  private_class_method :unzip

  setup
end

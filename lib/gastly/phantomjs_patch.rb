module Phantomjs
  class << self
    attr_accessor :proxy_host, :proxy_port
  end

  class Platform
    class << self
      def install!
        STDERR.puts "Phantomjs does not appear to be installed in #{phantomjs_path}, installing!"
        FileUtils.mkdir_p Phantomjs.base_dir

        # Purge temporary directory if it is still hanging around from previous installs,
        # then re-create it.
        temp_dir = File.join(temp_path, 'phantomjs_install')
        FileUtils.rm_rf temp_dir
        FileUtils.mkdir_p temp_dir

        Dir.chdir temp_dir do
          unless download_via_curl or download_via_wget
            raise "\n\nFailed to load phantomjs! :(\nYou need to have cURL or wget installed on your system.\nIf you have, the source of phantomjs might be unavailable: #{package_url}\n\n"
          end

          case package_url.split('.').last
            when 'bz2'
              system "bunzip2 #{File.basename(package_url)}"
              system "tar xf #{File.basename(package_url).sub(/\.bz2$/, '')}"
            when 'zip'
              system "unzip #{File.basename(package_url)}"
            else
              raise "Unknown compression format for #{File.basename(package_url)}"
          end

          # Find the phantomjs build we just extracted
          extracted_dir = Dir['phantomjs*'].find { |path| File.directory?(path) }

          if extracted_dir.nil?
            # Move the executable file
            FileUtils.mkdir_p File.join(Phantomjs.base_dir, platform, 'bin')
            if FileUtils.mv 'phantomjs', File.join(Phantomjs.base_dir, platform, 'bin')
              STDOUT.puts "\nSuccessfully installed phantomjs. Yay!"
            end
          else
            # Move the extracted phantomjs build to $HOME/.phantomjs/version/platform
            if FileUtils.mv extracted_dir, File.join(Phantomjs.base_dir, platform)
              STDOUT.puts "\nSuccessfully installed phantomjs. Yay!"
            end
          end

          # Clean up remaining files in tmp
          if FileUtils.rm_rf temp_dir
            STDOUT.puts 'Removed temporarily downloaded files.'
          end
        end

        raise 'Failed to install phantomjs. Sorry :(' unless File.exist?(phantomjs_path)
      end

      private

      def download_via_curl
        system "curl -L -O #{package_url} #{curl_proxy_options}"
      end

      def download_via_wget
        system "wget #{package_url} #{wget_proxy_options}"
      end

      def curl_proxy_options
        return '' if Phantomjs.proxy_host.nil? && Phantomjs.proxy_port.nil?
        "-x #{Phantomjs.proxy_host}:#{Phantomjs.proxy_port}"
      end

      def wget_proxy_options
        return '' if Phantomjs.proxy_host.nil? && Phantomjs.proxy_port.nil?
        "-e use_proxy=yes -e http_proxy=#{Phantomjs.proxy_host}:#{Phantomjs.proxy_port}"
      end
    end
  end
end

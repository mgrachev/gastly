require 'spec_helper'

RSpec.describe Gastly::Screenshot do
  let(:url) { 'http://google.com' }
  let(:params) do
    {
        selector:       '#hplogo',
        browser_width:  1280,
        browser_height: 780,
        timeout:        1000,
        cookies:        { user_id: 1, auth_token: 'abcd' },
        proxy_host:     '10.10.10.1',
        proxy_port:     '8080'
    }
  end
  subject { Gastly::Screenshot.new(url) }

  # Constants
  it { expect(Gastly::Screenshot::SCRIPT_PATH).to eq File.expand_path('../../../lib/gastly/script.js', __FILE__) }
  it { expect(Gastly::Screenshot::DEFAULT_TIMEOUT).to eq 0 }
  it { expect(Gastly::Screenshot::DEFAULT_BROWSER_WIDTH).to eq 1440 }
  it { expect(Gastly::Screenshot::DEFAULT_BROWSER_HEIGHT).to eq 900 }
  it { expect(Gastly::Screenshot::DEFAULT_FILE_FORMAT).to eq '.png' }

  context '#initialize' do
    it 'sets instance variables' do
      screenshot = Gastly::Screenshot.new(url, params)
      params.each do |key, value|
        expect(screenshot.public_send(key)).to eq value
      end
    end

    it 'raises an argument error' do
      expect { Gastly::Screenshot.new(url, url: url) }.to raise_error(ArgumentError)
    end
  end

  context '#capture' do
    it 'configures proxy' do
      expect(Phantomjs).to receive(:run)
      expect(Phantomjs).to receive(:proxy_host=).with(params[:proxy_host])
      expect(Phantomjs).to receive(:proxy_port=).with(params[:proxy_port])
      expect_any_instance_of(Gastly::Image).to receive(:initialize)
      Gastly::Screenshot.new(url, params).capture
    end

    it 'runs js script' do
      expect_any_instance_of(Gastly::Image).to receive(:initialize)

      screenshot = Gastly::Screenshot.new(url, params)
      cookies = params[:cookies].map { |key, value| "#{key}=#{value}" }.join(',')
      args = [
        "--proxy=#{params[:proxy_host]}:#{params[:proxy_port]}",
        Gastly::Screenshot::SCRIPT_PATH,
        "url=#{url}",
        "timeout=#{params[:timeout]}",
        "width=#{params[:browser_width]}",
        "height=#{params[:browser_height]}",
        "output=#{screenshot.image.path}",
        "selector=#{params[:selector]}",
        "cookies=#{cookies}"
      ]

      expect(Phantomjs).to receive(:run).with(*args)
      screenshot.capture
    end

    it 'raises an exception if fetch error' do
      url = 'h11p://google.com'
      screenshot = Gastly::Screenshot.new(url)
      expect { screenshot.capture }.to raise_error(Gastly::FetchError, "Unable to load #{url}")
    end

    it 'raises an exception if runtime error' do
      expect(Phantomjs).to receive(:run).and_return('RuntimeError:test runtime error')
      screenshot = Gastly::Screenshot.new(url)
      expect { screenshot.capture }.to raise_error(Gastly::PhantomJSError, 'test runtime error')
    end

    it 'raises an exception if unknown error' do
      expect(Phantomjs).to receive(:run).and_return('unknown error')
      screenshot = Gastly::Screenshot.new(url)
      expect { screenshot.capture }.to raise_error(Gastly::UnknownError)
    end

    it 'returns an instance of Gastly::Image' do
      screenshot = Gastly::Screenshot.new(url)
      expect(screenshot.capture).to be_instance_of Gastly::Image
    end
  end

  context '#timeout' do
    it 'returns default timeout' do
      expect(subject.timeout).to eq Gastly::Screenshot::DEFAULT_TIMEOUT
    end

    it 'returns the set value' do
      screenshot = described_class.new(url, timeout: 200)
      expect(screenshot.timeout).to eq 200
    end
  end

  context '#browser_width' do
    it 'returns default browser width' do
      expect(subject.browser_width).to eq Gastly::Screenshot::DEFAULT_BROWSER_WIDTH
    end

    it 'returns the set value' do
      screenshot = described_class.new(url, browser_width: 1280)
      expect(screenshot.browser_width).to eq 1280
    end
  end

  context '#browser_height' do
    it 'returns default browser height' do
      expect(subject.browser_height).to eq Gastly::Screenshot::DEFAULT_BROWSER_HEIGHT
    end

    it 'returns the set value' do
      screenshot = described_class.new(url, browser_height: 720)
      expect(screenshot.browser_height).to eq 720
    end
  end
end
require 'spec_helper'

RSpec.describe Gastly::Screenshot do
  let(:url) { 'http://google.com' }
  subject { described_class.new(url) }

  # Constants
  it { expect(Gastly::Screenshot::SCRIPT_PATH).to eq File.expand_path('../../../lib/gastly/script.js', __FILE__) }
  it { expect(Gastly::Screenshot::DEFAULT_TIMEOUT).to eq 0 }
  it { expect(Gastly::Screenshot::DEFAULT_BROWSER_WIDTH).to eq 1440 }
  it { expect(Gastly::Screenshot::DEFAULT_BROWSER_HEIGHT).to eq 900 }
  it { expect(Gastly::Screenshot::DEFAULT_FILE_NAME).to eq 'output' }
  it { expect(Gastly::Screenshot::DEFAULT_FILE_FORMAT).to eq '.png' }

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
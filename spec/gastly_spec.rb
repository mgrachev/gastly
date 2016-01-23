require 'spec_helper'

describe Gastly do
  let(:url) { 'http://google.com' }

  context '#screenshot' do
    it 'returns an instance of Gastly::Screenshot' do
      expect(Gastly.screenshot(url, timeout: 1000)).to be_instance_of Gastly::Screenshot
    end
  end

  context '#capture' do
    it 'creates a screenshot' do
      tmp = 'spec/support/tmp'
      path = "#{tmp}/output.png"
      expect { Gastly.capture(url, path) }.to change { Dir.glob("#{tmp}/*").length }.by(1)
      FileUtils.rm Dir.glob("#{tmp}/*")
    end
  end
end

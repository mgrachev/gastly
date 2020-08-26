require 'spec_helper'

RSpec.describe Gastly::Image do
  let(:image) { MiniMagick::Image.new('test.png') }
  subject { Gastly::Image.new(image) }

  context '#resize' do
    it 'invokes method #resize with arguments' do
      width, height = 100, 100
      expect_any_instance_of(MiniMagick::Image).to receive(:resize).with("#{width}x#{height}")
      subject.resize(width: 100, height: 100)
    end
  end

  context '#crop' do
    it 'invokes method #crop with arguments' do
      width, height, x, y = 100, 100, 0, 0
      expect_any_instance_of(MiniMagick::Image).to receive(:crop).with("#{width}x#{height}+#{x}+#{y}")
      subject.crop(width: 100, height: 100, x: 0, y: 0)
    end
  end

  context '#format' do
    it 'invokes method #format' do
      ext = 'png'
      expect_any_instance_of(MiniMagick::Image).to receive(:format).with(ext)
      subject.format(ext)
    end
  end

  context '#save' do
    let(:output) { 'output.png' }
    before do
      expect_any_instance_of(MiniMagick::Image).to receive(:write).with(output)
    end

    it 'invokes method #write' do
      subject.save(output)
    end

    it 'returns a string' do
      expect(subject.save(output)).to eq output
    end
  end
end
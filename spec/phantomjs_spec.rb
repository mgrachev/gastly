require 'spec_helper'

describe Phantomjs do
  it { expect(Phantomjs).to respond_to(:proxy_host) }
  it { expect(Phantomjs).to respond_to(:proxy_port) }
end

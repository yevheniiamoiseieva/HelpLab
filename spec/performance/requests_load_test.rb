require 'rails_helper'
require 'benchmark'

RSpec.describe 'Performance testing' do
  describe 'Requests index page' do
    before do
      100.times { create(:request) }
    end

    it 'loads under 500ms' do
      time = Benchmark.realtime { get requests_path }
      expect(time).to be < 0.5
    end

    it 'handles 1000 requests efficiently' do
      expect {
        1000.times { get requests_path }
      }.not_to raise_error
    end
  end
end
require 'rails_helper'

RSpec.describe EtfProvider::Xtb do
  subject(:instruments) { described_class.call }

  before do
    stub_request(:get, 'https://www.xtb.com/api/pl/instruments/get?instrumentTypeSlug=etfs&page=0&queryString=')
      .to_return(status: 200, body: file_fixture('api/xtb/instruments/page0.json'))
    stub_request(:get, 'https://www.xtb.com/api/pl/instruments/get?instrumentTypeSlug=etfs&page=1&queryString=')
      .to_return(status: 200, body: file_fixture('api/xtb/instruments/page1.json'))
    stub_request(:get, 'https://www.xtb.com/api/pl/instruments/get?instrumentTypeSlug=etfs&page=2&queryString=')
      .to_return(status: 200, body: file_fixture('api/xtb/instruments/page2.json'))
  end

  it { is_expected.not_to be_empty }
  it { expect(instruments.size).to eq(321) }

  it { expect(PendingEtf.to_csv(instruments)).to eq(file_fixture('pending_etfs/xtb.csv')) }

  # it do
  #   PendingEtf.dump(instruments, 'spec/fixtures/files/pending_etfs/xtb.csv')
  # end
end
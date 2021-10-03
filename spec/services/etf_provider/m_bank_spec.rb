require 'rails_helper'

RSpec.describe EtfProvider::MBank do
  subject(:instruments) { described_class.call }

  before do
    stub_request(:get, 'https://www.mbank.pl/pdf/ind/inwestycje/lista-funduszy-etf.pdf')
      .to_return(status: 200, body: file_fixture('api/mbank/lista-funduszy-etf.pdf'))
  end

  it { is_expected.not_to be_empty }
  it { expect(instruments.size).to eq(20) }

  it { expect(PendingEtf.to_csv(instruments)).to eq(file_fixture('pending_etfs/mbank.csv').read) }

  # it do
  #   PendingEtf.dump(instruments, 'spec/fixtures/files/pending_etfs/mbank.csv')
  # end
end
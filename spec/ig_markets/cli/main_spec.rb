describe IGMarkets::CLI::Main, :dealing_platform do
  before do
    IGMarkets::CLI::Main.instance_variable_set :@dealing_platform, dealing_platform
  end

  def cli(arguments = {})
    IGMarkets::CLI::Main.new [], { username: 'username', password: 'password', api_key: 'api-key' }.merge(arguments)
  end

  it 'signs in' do
    expect(dealing_platform).to receive(:sign_in).with('username', 'password', 'api-key', :live)

    IGMarkets::CLI::Main.begin_session(cli.options) { |_dealing_platform| }
  end

  it 'reports a connection error' do
    expect(dealing_platform).to receive(:sign_in).and_raise(IGMarkets::Errors::ConnectionError)

    expect do
      IGMarkets::CLI::Main.begin_session(cli.options) { |_dealing_platform| }
    end.to output("ig_markets: ConnectionError\n").to_stderr.and raise_error(SystemExit)
  end

  it 'reports a connection error with details' do
    expect(dealing_platform).to receive(:sign_in).and_raise(IGMarkets::Errors::ConnectionError.new('details'))

    expect do
      IGMarkets::CLI::Main.begin_session(cli.options) { |_dealing_platform| }
    end.to output("ig_markets: ConnectionError, details\n").to_stderr.and raise_error(SystemExit)
  end

  it 'reports a deal confirmation' do
    deal_confirmation = build :deal_confirmation, profit: -1.5

    expect(dealing_platform).to receive(:deal_confirmation).with('reference').and_return(deal_confirmation)

    expect { IGMarkets::CLI::Main.report_deal_confirmation 'reference' }.to output(<<-MSG
Deal reference: reference
Deal ID: DEAL
Status: Accepted
Result: Amended
Profit/loss: #{ColorizedString['USD -1.50'].red}
MSG
                                                                                  ).to_stdout
  end

  it 'reports a deal confirmation that was rejected' do
    deal_confirmation = build :deal_confirmation, deal_status: :rejected, reason: :unknown

    expect(dealing_platform).to receive(:deal_confirmation).with('reference').and_return(deal_confirmation)

    expect { IGMarkets::CLI::Main.report_deal_confirmation 'reference' }.to output(<<-MSG
Deal reference: reference
Deal ID: DEAL
Status: Rejected
Result: Amended
Profit/loss: #{ColorizedString['USD 150.00'].green}
Reason: Unknown
MSG
                                                                                  ).to_stdout
  end

  it 'retries the deal confirmation request multiple times if the attempts return deal not found' do
    deal_confirmation = build :deal_confirmation

    expect(dealing_platform)
      .to receive(:deal_confirmation)
      .twice.with('reference')
      .and_raise(IGMarkets::Errors::DealNotFoundError)
    expect(IGMarkets::CLI::Main).to receive(:sleep).twice.with(2)
    expect(dealing_platform).to receive(:deal_confirmation).with('reference').and_return(deal_confirmation)

    expect { IGMarkets::CLI::Main.report_deal_confirmation 'reference' }.to output(<<-MSG
Deal reference: reference
Deal not found, retrying ...
Deal not found, retrying ...
Deal ID: DEAL
Status: Accepted
Result: Amended
Profit/loss: #{ColorizedString['USD 150.00'].green}
MSG
                                                                                  ).to_stdout
  end

  it 'retries the deal confirmation request five times if the attempts return deal not found and then fails' do
    expect(dealing_platform)
      .to receive(:deal_confirmation)
      .exactly(5).times.with('reference')
      .and_raise(IGMarkets::Errors::DealNotFoundError)
    expect(IGMarkets::CLI::Main).to receive(:sleep).exactly(4).times.with(2)

    expect { IGMarkets::CLI::Main.report_deal_confirmation 'reference' }
      .to output(<<-MSG
Deal reference: reference
Deal not found, retrying ...
Deal not found, retrying ...
Deal not found, retrying ...
Deal not found, retrying ...
MSG
                ).to_stdout.and raise_error(IGMarkets::Errors::DealNotFoundError)
  end

  it 'reports the version' do
    ['-v', '--version'].each do |argument|
      expect do
        IGMarkets::CLI::Main.bootstrap [argument]
      end.to output("#{IGMarkets::VERSION}\n").to_stdout.and raise_error(SystemExit)
    end
  end

  it 'runs with no config file' do
    expect(IGMarkets::CLI::Main).to receive(:config_file).and_return(IGMarkets::CLI::ConfigFile.new)
    expect(IGMarkets::CLI::Main).to receive(:start).with(['--test'])

    IGMarkets::CLI::Main.bootstrap ['--test']
  end

  it 'ignores config files when running help commands' do
    expect(IGMarkets::CLI::Main).not_to receive(:config_file)
    expect(IGMarkets::CLI::Main).to receive(:start).with(['help'])

    IGMarkets::CLI::Main.bootstrap ['help']
  end

  it 'uses a config file if present' do
    config_file = IGMarkets::CLI::ConfigFile.new('profiles' => { 'default' => { 'username' => 'USERNAME' } })

    expect(IGMarkets::CLI::Main).to receive(:config_file).and_return(config_file)
    expect(IGMarkets::CLI::Main).to receive(:start).with(['--username=USERNAME', '--test'])

    IGMarkets::CLI::Main.bootstrap ['--test']
  end

  it 'finds a config file in the working directory and home directory' do
    expect(Dir).to receive(:pwd).and_return('pwd')
    expect(Dir).to receive(:home).and_return('home')

    config_file = IGMarkets::CLI::ConfigFile.new

    expect(IGMarkets::CLI::ConfigFile).to receive(:find)
      .with('pwd/.ig_markets.yml', 'home/.ig_markets.yml')
      .and_return(config_file)

    expect(IGMarkets::CLI::Main).to receive(:start).with([])

    IGMarkets::CLI::Main.bootstrap []
  end
end

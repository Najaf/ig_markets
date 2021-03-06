describe IGMarkets::RequestBodyFormatter do
  class RequestBodyModel < IGMarkets::Model
    attribute :the_string
    attribute :the_symbol, Symbol, allowed_values: [:two_three]
    attribute :the_date, Date, format: '%F'
  end

  it 'formats request bodies' do
    model = RequestBodyModel.new the_string: 'string', the_symbol: :two_three, the_date: Date.new(2010, 10, 20)

    expect(described_class.format(model)).to eq(theString: 'string', theSymbol: 'TWO_THREE',
                                                theDate: '2010-10-20')
  end

  it 'applies defaults' do
    model = RequestBodyModel.new the_string: 'string'

    expect(described_class.format(model, default: '1')).to eq(theString: 'string', default: '1')
  end

  it 'camel cases snake case strings' do
    expect(described_class.snake_case_to_camel_case('one')).to eq(:one)
    expect(described_class.snake_case_to_camel_case('one_two_three')).to eq(:oneTwoThree)
  end
end

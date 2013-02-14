require 'rspectacular'
require 'pinpoint/format/parser'

describe Pinpoint::Format::Parser do
  let(:parser_class)    { Pinpoint::Format::Parser }
  let(:parsable_string) { '(%s, )((%l, )(%p )%z)(, %c)' }
  let(:parser)          { parser_class.new(parsable_string) }

  context 'when the parsable string contains literal parenthesis' do
    let(:parsable_string) { '%)%((%((%))%)%%%))' }

    it 'can properly parse a string' do
      parser.parse.should eql [
        ')',
        '(',
        [
          '(',
          [
            ')'
          ],
          ')',
          '%',
          ')'
        ]
      ]
    end
  end

  it 'checks that the token set is valid before attempting to process it' do
    parser.send(:tokens).should_receive :valid?

    parser.parse
  end

  context 'when the parsable string is typical' do
    it 'can properly parse a string' do
      parser.parse.should eql [
        [
          :street,
          ', ',
        ],
        [
          [
            :locality,
            ', '
          ],
          [
            :province,
            ' '
          ],
          :postal_code
        ],
        [
          ', ',
          :country
        ]
      ]
    end
  end
end

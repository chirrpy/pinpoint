require 'rspectacular'
require 'pinpoint/format/tokenizer'

describe Pinpoint::Format::Tokenizer do
  let(:tokenizer_class) { Pinpoint::Format::Tokenizer }
  let(:tokenable)       { '((%s), )(((%p) )(%z))(, (%c))' }
  let(:tokenizer)       { Pinpoint::Format::Tokenizer.new(tokenable) }

  it 'can process a String into Tokens' do
    tokenizer.to_tokens.should eql [
      [:group_start,  '('   ],
      [:group_start,  '('   ],
      [:street,       '%s'  ],
      [:group_end,    ')'   ],
      [:literal,       ', ' ],
      [:group_end,    ')'   ],
      [:group_start,  '('   ],
      [:group_start,  '('   ],
      [:group_start,  '('   ],
      [:province,     '%p'  ],
      [:group_end,    ')'   ],
      [:literal,       ' '  ],
      [:group_end,    ')'   ],
      [:group_start,  '('   ],
      [:postal_code,  '%z'  ],
      [:group_end,    ')'   ],
      [:group_end,    ')'   ],
      [:group_start,  '('   ],
      [:literal,       ', ' ],
      [:group_start,  '('   ],
      [:country,      '%c'  ],
      [:group_end,    ')'   ],
      [:group_end,    ')'   ]
    ]
  end

  context 'when the String passed contains literal percent sign tokens' do
    let(:tokenable) { '%%%c' }

    it 'parses correctly' do
      tokenizer.to_tokens.should eql [
        [:percent,      '%%' ],
        [:country,      '%c' ]
      ]
    end
  end

  context 'when the String passed contains an improper syntax' do
    let(:tokenable) { '%%%c%io' }

    it 'parses correctly' do
      expect { tokenizer.to_tokens }.to raise_error(
        Pinpoint::Format::Tokenizer::ParseError,
        "Cannot parse the remainder of the tokenable string: '%io'"
      )
    end
  end

  context 'when the String passed contains complex grouping and parenthesis literals' do
    let(:tokenable) { '%)%((%((%))%)%%%))' }

    it 'parses correctly' do
      tokenizer.to_tokens.should eql [
        [:right_paren,  '%)'  ],
        [:left_paren,   '%('  ],
        [:group_start,  '('   ],
        [:left_paren,   '%('  ],
        [:group_start,  '('   ],
        [:right_paren,  '%)'  ],
        [:group_end,    ')'   ],
        [:right_paren,  '%)'  ],
        [:percent,      '%%'  ],
        [:right_paren,  '%)'  ],
        [:group_end,    ')'   ]
      ]
    end
  end
end

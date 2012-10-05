guard 'rspec',
      all_on_start:   true,
      all_after_pass: true,
      cli:            '--format Fuubar',
      notification:   true do

  watch(%r{^(spec\/.+_spec\.rb)$})   { |m| m[1] }
  watch(%r{^lib/pinpoint\.rb$})      { |m| "spec/pinpoint_spec.rb" }
  watch(%r{^lib/pinpoint/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end

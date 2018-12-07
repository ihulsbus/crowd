#!/usr/bin/ruby

def url(version)
  "https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-crowd-#{version}.tar.gz"
end

def tmp
  '/tmp/confluence'
end

def getsum(v)
  file = "crowd-#{v}-1"
  `wget -q --show-progress -O #{tmp}/#{file} #{url(v)}`
  c = `shasum -a 256 #{tmp}/#{file}`.split(' ')[0]
  `rm #{tmp}/#{file}`
  #puts '    ' + c

  return c
end

def fetch
  `mkdir -p #{tmp} 2> /dev/null`

  block = "        {\n"
  versions.each do |v|

    c1 = getsum(v)
    c2 = getsum(v)

    if (c1 == c2)
      block = block + "          '#{v}' => '#{c1}',\n"
      puts block
    else
      puts 'CHECK FAILED SKIPPING'
    end
  end

  block = block + "        }\n"

  puts
  puts
  puts block
end

def versions
  [
  '3.3.0',
  '3.2.6',
  '3.2.5',
  '3.2.3',
  '3.2.2',
  '3.2.1',
  '3.2.0',
  '3.1.5',
  '3.1.4',
  '3.1.3',
  '3.1.2',
  '3.1.1',
  '3.0.3',
  '3.0.2',
  '3.0.1',
  '3.0.0',
  '2.12.0',
  '2.11.2',
  '2.11.1',
  '2.11.0',
  '2.10.3',
  '2.10.2',
  '2.10.1',
  '2.9.7',
  '2.9.5',
  '2.9.1',
  '2.8.8',
  '2.8.4',
  '2.8.3',
  '2.8.2',
  '2.8.0',
  '2.7.2',
  '2.7.1',
  '2.7.0',
  '2.6.7',
  '2.6.5',
  '2.6.4',
  '2.6.3',
  '2.6.2',
  '2.6.1',
  '2.6.0',
  '2.5.7',
  '2.5.5',
  '2.5.4',
  '2.5.3',
  '2.5.2',
  '2.5.1',
  '2.5.0',
  '2.4.10',
  '2.4.2',
  '2.4.1',
  '2.4.0',
  '2.3.9',
  '2.3.7',
  '2.3.6',
  '2.3.4',
  '2.3.3',
  '2.3.2',
  '2.3.1',
  '2.2.9',
  '2.2.7',
  '2.2.4',
  '2.2.2',
  '2.1.2',
  '2.1.1',
  '2.1.0',
  '2.0.9',
  '2.0.7',
  '2.0.6',
  '2.0.5',
  '2.0.4',
]
end

fetch
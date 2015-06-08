#!/usr/bin/env ruby
#
#   Author: Tom Llewellyn-Smith <tom@onixconsulting.co.uk>
#   Copyright: © Onix Consulting Limited 2012-2015. All rights reserved.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require 'docklean'
require 'optparse'

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"
    opts.on("-c CONFIG","--config", "YAML config") do |c|
        options[:config] = c
    end
end.parse!

config = options[:config] ||= 'bin/config.yaml'

docklean = Docklean.new(config)

# cleans up all containers older than max_age and removes unused images
docklean.scrub()

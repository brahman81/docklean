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
require 'date'
require 'docklean/base'
require 'docklean/conf'
require 'docklean/containers'
require 'docklean/error'
require 'docklean/images'

class Docklean
    include Docklean::Base
    include Docklean::Conf
    include Docklean::Containers
    include Docklean::Images

    def initialize(config)  
        begin
            if File.exists?(config) then
                puts "info: #{config} exists using it"
                self.read(config)
                @docker_bin = self.get_conf('docker_bin')
                @max_age = self.get_conf('max_age')
            end
        rescue Docklean::ErrorNoConfiguration
            puts "error: please provide a YAML configuration"
            exit
        end
            
    end

    def dump()
        puts self.inspect
    end
end

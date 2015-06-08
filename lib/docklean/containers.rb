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
class Docklean
    module Containers
        def get_containers()
            @containers = Hash.new()
            %x{#{@docker_bin} ps --no-trunc=true -q -a}.split(/\n/).each do |container|
                container.chomp()
                name,image_id,is_running,start_at,end_at = %x{#{@docker_bin} inspect --format "{{.Name}};{{.Image}};{{.State.Running}};{{.State.StartedAt}};{{.State.FinishedAt}}" #{container}}.split(/;/)
                @containers[container.to_sym] = {
                    :name => name.gsub(/^\//,''),
                    :image_id => image_id.chomp(),
                    :is_running => is_running.chomp(),
                    :start_at => DateTime.parse(start_at.chomp().to_s).strftime('%s'),
                    :end_at => DateTime.parse(end_at.chomp().to_s).strftime('%s'),
                    :run_time => (DateTime.parse(end_at.chomp().to_s).strftime('%s').to_i - DateTime.parse(start_at.chomp().to_s).strftime('%s').to_i),
                    :age => (Time.now.to_i - DateTime.parse(start_at.chomp().to_s).strftime('%s').to_i)
                }
            end
        end

        def cleanup_containers()
            @images_to_keep = Array.new()
            self.get_containers()
            @containers.each do |container,meta|
                case meta[:is_running].chomp
                    when 'false'
                        # check it's older than MAX_AGE
                        if meta[:age] >= @max_age then
                            # only remove container if it doesn't match keep_filter
                            unless meta[:name].match(%r{#{self.get_conf('keep_filter')}}) then
                                %x{#{@docker_bin} rm #{container.to_s.chomp}}
                                puts "info: deleting #{container.to_s.chomp} (container)"
                            else
                                # do not delete this image_id
                                @images_to_keep.push(meta[:image_id])
                            end
                        else
                            # do not delete this image_id
                            @images_to_keep.push(meta[:image_id])
                            puts "info: #{container} (container) not old enough, do not delete #{meta[:image_id]} (image)"
                        end
                    when 'true'
                        # do not delete this image_id
                        @images_to_keep.push(meta[:image_id])
                        puts "info: #{meta[:image_id]} (image) in use by #{container} (container) do not delete"
                end
            end
        end
    end
end

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
    module Images
        def delete_dangling()
            unless %x{#{@docker_bin} images -q -f dangling=true}.to_s.empty? then
                puts "info: deleting dangling images"
                %x{#{@docker_bin} rmi $(#{@docker_bin} images -q -f dangling=true)}
            end
        end

        def cleanup_images()
            # loop over all images, do not process duplicates, delete when not needed
            %x{#{@docker_bin} images -q --no-trunc=true}.split(/\n/).uniq.each do |image|
                if @images_to_keep.include?(image.chomp) then
                    # do not delete this image
                else
                    # safe to delete this image
                    puts "info: deleting #{image.chomp} (image)"
                    %x{#{@docker_bin} rmi #{image.chomp}}
                end
            end
            # cleanup dangling images (<none>)
            self.delete_dangling()
        end
    end
end

# Title: Jekyll Picture
# Authors:
# Download:
# Documentation:
#
# Syntax:
# Example:
# Output:

### ruby 1.9+

require 'fileutils'
require 'mini_magick'
require 'digest/md5'

module Jekyll

  class Picture < Liquid::Tag

    def initialize(tag_name, markup, tokens)


      if tag = /^(?:(?<preset>[^\s.:]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<source_src>(?:(source_[^\s:]+:\s+[^\s]+\.[a-zA-Z0-9]{3,4})\s*)+)?(?<html_attr>[\s\S]+)?$/.match(markup)

        @preset = tag[:preset] || 'default'
        @image_src = tag[:image_src]
        @source_src = {}
        if tag[:source_src]
          @source_src = Hash[ *tag[:source_src].gsub(/:/, '').split ]
        end
        @html_attr = {}
        if tag[:html_attr]
          tag[:html_attr].scan(/(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?/).each do |html_attr|
            @html_attr.merge! Hash[*html_attr]
          end
        end

      else
        raise SyntaxError.new("Your picture tag doesn't seem to be formatted correctly. Try {% picture [preset_name] path/to/img.jpg [source_key: path/to/alt/img.jpg] [attribute=\"value\"] %}.")
      end
      super
    end

    ### Ruby style assignment notes
    ### If parent_id is nil or undefined before that line you can simply write:
    ### parent_id = params[:parent_id] unless params[:parent_type] == "Order"

    ### parent_id = (params[:parent_type] == "Order") ? nil : params[:parent_id]
    ### Alternatively:

    ### parent_id = if (params[:parent_type] == "Order")
    ###     nil
    ### else
    ###     params[:parent_id]
    ### end

    ### @going, @not_going = invite.accepted ? ['selected', ''] : ['', 'selected']
    ### w, x = y, z is the same as w, x = [y, z], so this works just fine and there is no repetition.

    ##### I like this!
    ### if cond; foo else bar end
    ### if cond then foo else bar end


    def render(context)

      ### All vars are REFERENCES
      ### DUDE ^^^^^^^^^^^^^^^^^^

      # Gather settings
      site = context.registers[:site]
      settings = site.config['picture']
      site_path = site.source
      markup = settings['markup'] || 'picturefill'
      asset_path = settings['asset_path'] || ''
      gen_path = settings['generated_path'] || File.join(asset_path, 'generated')

      # Create sources object and settings
      # Deep copy preset for manipulation. Is there a better way?
      sources = Marshal.load(Marshal.dump(settings['presets'][@preset]))
      html_attr = if sources['attr'] then sources.delete('attr').merge!(@html_attr) else @html_attr end
      ppi = if sources['ppi'] then sources.delete('ppi').sort.reverse else nil end
      source_keys = sources.keys

      # Process attributes
      if markup == 'picturefill'
        html_attr['data-picture'] = nil
        html_attr['data-alt'] = html_attr.delete('alt')
      end

      html_attr_string = ''
      html_attr.each {|key, value|
        if value
          html_attr_string += "#{key}=\"#{value}\" "
        else
          html_attr_string += "#{key} "
        end
      }

      # Process sources

      ### check if sources don't exist in preset, raise error
      if (@source_src.keys - source_keys).any?
        raise SyntaxError.new("You're trying to specify an image for a source that doesn't exist. Please check picture: presets: #{@preset} in your _config.yml for the list of available sources.")
      end

      # Add image path for each source
      sources.each { |key, value|
        sources[key][:src] = @source_src[key] || @image_src
      }


      # Process PPIs

      # Add resolution based sources

      ### Not sure what the most elegant way to do this is.
      ### Here's the pieces though, with some suggestions.

      ### if ppi

      ### sources.each { |key, source|
      ### ppi.each { |p|

      ### if p != 1
      ### new_key = key + "_" + (p * 1000)
      ### new_width = source['width'] * p
      ### new_height = source['height'] * p
      ### new_media = source['media'] + " and (min-resolution: " + p + "dppx), " +
      ###             source['media'] + " and (min-resolution: " + (p * 96) + "dpi)"
      ### use existing src
      ### MQ Reference: http://www.brettjankord.com/2012/11/28/cross-browser-retinahigh-resolution-media-queries/

      ### create new hash
      ### append new hash onto end of sources hash

      ### if p > 1, insert new_key before key in source_keys
      ### if p < 1, insert new_key after key in source_keys

      # Generate sized images
      sources.each { |key, source|
        sources[key][:generated_src] = generate_image(source, site_path, asset_path, gen_path)
      }

      # Construct and return tag

      "<pre>Hey dog!</pre>"

      # if settings['markup'] == 'picturefill'

      # ### Not updated for new variables
      # # <span tag[:attributes]>
      # #   each source_key in @tag[:sources]
      # #     if !source_key['source'], source_key['source'] = @image_src
      # #   <span data-src="source_key[img_path]" (if media) data-media="source_key[media]"></span>
      # #   endeach
      # #
      # #   <noscript>
      # #     <img src="@tag[:sources][source_default][img_path]" alt="@tag[:alt]">
      # #   </noscript>
      # # </span>

      # elsif settings['markup'] == 'picture'

      # ### Not updated for new variables
      # # <picture @tag[:attributes]>
      # #   each source_key in @tag[:sources]
      # #   <source src="source_key[img_path]"
      # #           (if media) media="source_key[media]">
      # #    <img src="small.jpg" alt="">
      # #    <p>@tag[:alt]</p>
      # # </picture>

      # end
    end

    def generate_image(source, site_path, asset_path, gen_path)

      ### We should hash the images to, for cache busting.

      if source['width'].nil? && source['height'].nil?
        raise SyntaxError.new("Source keys must have at least one of width and height in the _config.yml.")
      end

      src_dir = File.dirname(source[:src])
      ext = File.extname(source[:src])
      src_name = File.basename(source[:src], ext)

      # file open
      # hash
      # add to minim read

      src_image = MiniMagick::Image.open(File.join(site_path, asset_path, source[:src]))
      src_ratio = src_image[:width].to_f / src_image[:height].to_f

      #### Hash orig file
      #### grab 4 digets
      #### add to dist file name to check

      # digest = Digest::MD5.hexdigest()
      # puts digest


      ### Need to round calcs, or does minimaj take care of that?
      ### Clean up all the to_i/f in here

      gen_width = source['width'] ? source['width'].to_i : (src_ratio * source['height'].to_f).to_i
      gen_height = source['height'] ? source['height'].to_i : (source['width'].to_f / src_ratio).to_i
      gen_ratio = gen_width.to_f/gen_height.to_f

      gen_name = "#{src_name}-#{gen_width}-#{gen_height}"
      gen_absolute_path = File.join(site_path, gen_path, src_dir, gen_name + ext)
      gen_return_path = File.join(gen_path, src_dir, gen_name + ext)

      if not File.exists?(gen_absolute_path)

        ### create the directory if it doesnt exist
        FileUtils.mkdir_p(File.join(site_path, gen_path)) unless File.exist?(File.join(site_path, gen_path))

        src_image.combine_options do |i|
          i.resize "#{gen_width}x#{gen_height}^"
          i.gravity "center"
          i.crop "#{gen_width}x#{gen_height}+0+0"
        end

        src_image.write gen_absolute_path
      end

      gen_return_path
    end

  end
end

Liquid::Template.register_tag('picture', Jekyll::Picture)

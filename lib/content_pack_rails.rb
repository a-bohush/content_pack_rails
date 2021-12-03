require "content_pack_rails/version"

module ContentPackRails
  def self.init(configs = { pack_name: 'content_pack' })
    Module.new do
      silent = proc { |&block| v = $VERBOSE; $VERBOSE = nil; res = block.call; $VERBOSE = v; res }
      to_content_id = -> (id) { "_id_#{configs[:pack_name]}_#{id}".to_sym }

      define_method configs[:pack_name] do |id, content=nil, options={}, &block|
        _id = to_content_id.call(id)
        _block = proc { block.call(id) } if block
        options[:append] || options[:flush] || content_for?(_id) && return
        content_for(_id, content, options.slice(:flush), &_block)
        (silent.call { instance_variable_get(:"@_#{configs[:pack_name]}_ids") } ||
          instance_variable_set(:"@_#{configs[:pack_name]}_ids", Set.new)).add(_id)
      end

      define_method "provide_#{configs[:pack_name]}" do
        instance_variable_get(:"@_#{configs[:pack_name]}_ids").inject("") do |acc, id|
          acc.concat(content_for(id))
        end
      end

      define_method "#{configs[:pack_name]}_get" do |id|
        content_for(to_content_id.call(id))
      end
    end
  end

  include init
end

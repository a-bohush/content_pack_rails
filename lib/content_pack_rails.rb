require "content_pack_rails/version"

module ContentPackRails
  def self.init(configs = { pack_name: 'content_pack' })
    Module.new do
      silent = proc { |&block| v = $VERBOSE; $VERBOSE = nil; res = block.call; $VERBOSE = v; res }

      define_method configs[:pack_name] do |id, content=nil, options={}, &block|
        _id = "_id_#{configs[:pack_name]}_#{id}".to_sym
        _block = proc { block.call(id) } if block
        options[:append] || options[:flush] || content_for?(_id) && return
        content_for(_id, content, options.slice(:flush), &_block)
        (silent.call { instance_variable_get(:"@_#{configs[:pack_name]}_ids") } ||
          instance_variable_set(:"@_#{configs[:pack_name]}_ids", Set.new)).add(_id)
      end

      define_method "provide_#{configs[:pack_name]}" do
        content_for(configs[:pack_name], nil, flush: true)
        instance_variable_get(:"@_#{configs[:pack_name]}_ids").each do |id|
          content_for(configs[:pack_name]) { content_for(id) }
        end
        content_for(configs[:pack_name])
      end
    end
  end

  include init
end

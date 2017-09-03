# Monkey patch
class Trocla::Store
  def search(key)
    raise 'not implemented'
  end
end

class Trocla::Stores::Moneta < Trocla::Store
  def search(key)
    search_keys(key)
  end

  private
  def search_keys(key)
    _moneta = Moneta.new(store_config['adapter'], (store_config['adapter_options']||{}).merge({ :expires => false }))
    a = []
    if store_config['adapter'] == :Sequel
      keys = _moneta.adapter.backend[:trocla].select_order_map {from_base64(:k)}
    elsif store_config['adapter'] == :YAML
      keys = _moneta.adapter.backend.transaction(true) { _moneta.adapter.backend.roots }
    end
    regexp = Regexp.new("^#{key}")
    keys.each do |k|
      a << k if regexp.match(k)
    end
    a
  end
end

class Trocla
  def search_key(key)
    store.search(key)
  end
end

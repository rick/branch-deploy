# frozen_string_literal: true

unless Hash.method_defined? :except
  class Hash
    def except(*keys)
      if keys.size > 4 && size > 4 # index if O(m*n) is big
        h = {}
        keys.each { |key| h[key] = true }
        keys = h
      end
      reject { |key, _value| keys.include? key }
    end
  end
end

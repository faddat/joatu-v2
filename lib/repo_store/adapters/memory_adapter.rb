module RepoStore
  module Adapters
    class MemoryAdapter < BaseAdapter
      def initialize
        @map = RepoStore::RecordMap.new
      end
    end
  end
end

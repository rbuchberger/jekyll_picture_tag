require 'concurrent-ruby'
require 'set'

module PictureTag
  # This is a global concurrent-ruby pool for executing tasks in parallel.
  # Pool itself should only be used in a single threaded context, and its
  # start method must be called prior to submitting to Pool.pool, and stop
  # must be called after.
  class Pool
    # We use a class variable to store pool to emulate a global singleton.
    # rubocop:disable Style/ClassVars
    @@_pool = nil
    # Because we're processing in parallel, we can't use existince in the
    # filestystem to prevent duplicate handling of files without a race
    # condition, so we manually track generated files here so we don't attempt
    # to generate the same image twice.
    @@_seen_files = Set[]

    def self.start_pool
      @@_pool = Concurrent::ThreadPoolExecutor.new(
        min_threads: 1, max_threads: Concurrent.processor_count,
        max_queue: 2 * Concurrent.processor_count
      )
    end

    def self.start_test_pool
      # Stub in an pool which executes immediately to avoid race conditions
      # during unit tests.
      @@_pool = Concurrent::ImmediateExecutor.new
      @@_seen_files = Set[]
    end

    def self.generate(generated_image)
      return if @@_seen_files.include?(generated_image.name)

      @@_seen_files.add(generated_image.name)
      @@_pool.post do
        generated_image.generate
      end
    end

    def self.stop_pool
      @@_pool.shutdown
      @@_pool.wait_for_termination
      @@_seen_files = Set[]
    end
  end
  # rubocop:enable Style/ClassVars
end

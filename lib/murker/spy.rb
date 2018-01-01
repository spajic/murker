require 'murker/interaction'
require 'murker/generator'
require 'murker/repo'
require 'murker/validator'

module Murker
  class Spy
    attr_reader :interactions

    def initialize(&block)
      @block = block
      @interactions = []
    end

    def self.on(&block)
      require 'lurker/spec_helper' unless defined? Murker::SpecHelper

      spy = new(&block)
      Thread.current[:murker_spy] = spy
      spy.call
    ensure
      Thread.current[:murker_spy] = nil
    end

    def self.current
      Thread.current[:murker_spy]
    end

    def self.enabled?
      current.present?
    end

    def call
      @block.call.tap do |result|
        puts "Got #{interactions.count} interactions"
        interactions.each do |interaction|
          schema = Generator.call(interaction: interaction)
          puts "#{schema}\n\n"
          repo = Repo.new
          if repo.has_schema_for?(interaction)
            schema = repo.retreive_schema_for(interaction)
            res = Validator.call(interaction: interaction, schema: schema)
            raise RuntimeError, 'VALIDATION FAILED' unless res
          else
            repo.store_schema_for(interaction)
          end
        end
      end
    end

    def add_interaction_by_action_dispatch(request, response)
      @interactions << Interaction.from_action_dispatch(request, response)
    end
  end
end

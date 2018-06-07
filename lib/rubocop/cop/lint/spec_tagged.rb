# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      class SpecTagged < Cop
        MSG = 'カンマ(,)を忘れていませんか?'.freeze

        def on_send(node)
          receiver, method_name, *args = *node
          return unless [:raise, :fail].include?(method_name)
          return unless check_receiver(receiver)
          return unless check_args(args)

          add_offense(node, loc(args))
        end

        def autocorrect(node)
          _receiver, _method_name, *args = *node

          lambda do |corrector|
            corrector.insert_before(loc(args), ',')
          end
        end

        private

        def check_receiver(receiver)
          return true unless receiver
          return true if receiver.const_type? && receiver.const_name == 'Kernel'
          return false
        end

        def check_args(args)
          return false unless args.size == 1

          arg = args.first
          return false unless arg.send_type?
          _receiver, method_name, _args = *arg
          return method_name =~ /^[A-Z]/
        end

        def loc(args)
          arg = args.first
          _receiver, _method_name, inner_args = *arg
          end_pos   = inner_args.loc.begin.begin_pos
          begin_pos = arg.loc.selector.end_pos
          Parser::Source::Range.new(arg.loc.expression.source_buffer, begin_pos, end_pos)
        end
      end
    end
  end
end

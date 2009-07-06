module ControllerMatchers
  class UseLayout
    def initialize(expected)
      @expected = 'layouts/' + expected
    end

    def matches?(controller)
      @actual = controller.layout
      @actual == @expected
    end

    def failure_message
      return "expected layout #{@expected.inspect}, got #{@actual.inspect}", @expected, @actual
    end

    def negative_failure_message
      return "expected layout #{@expected.inspect} not to equal #{@actual.inspect}", @expected, @actual
    end
  end

  def use_layout(expected)
     UseLayout.new(expected)
  end
end

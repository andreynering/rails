# Most objects are cloneable, but not all. For example you can't dup +nil+:
#
#   nil.dup # => TypeError: can't dup NilClass
#
# Classes may signal their instances are not duplicable removing +dup+/+clone+
# or raising exceptions from them. So, to dup an arbitrary object you normally
# use an optimistic approach and are ready to catch an exception, say:
#
#   arbitrary_object.dup rescue object
#
# Rails dups objects in a few critical spots where they are not that arbitrary.
# That rescue is very expensive (like 40 times slower than a predicate), and it
# is often triggered.
#
# That's why we hardcode the following cases and check duplicable? instead of
# using that rescue idiom.
class Object
  # Can you safely .dup this object?
  # False for nil, false, true, symbols, numbers, class and module objects; true otherwise.
  def duplicable?
    true
  end
end

class NilClass
  # Instances of NilClass are not duplicable
  #
  # === Example
  #
  # nil.duplicable? # => false
  # nil.dup         # => TypeError: can't dup NilClass
  def duplicable?
    false
  end
end

class FalseClass
  # Instances of FalseClass are not duplicable
  #
  # === Example
  #
  # false.duplicable? # => false
  # false.dup         # => TypeError: can't dup FalseClass
  def duplicable?
    false
  end
end

class TrueClass
  # Instances of TrueClass are not duplicable
  #
  # === Example
  #
  # true.duplicable? # => false
  # true.dup         # => TypeError: can't dup TrueClass
  def duplicable?
    false
  end
end

class Symbol
  # Symbols are not duplicable
  #
  # === Example
  #
  # :my_symbol.duplicable? # => false
  # :my_symbol.dup         # => TypeError: can't dup Symbol
  def duplicable?
    false
  end
end

class Numeric #:nodoc:
  def duplicable?
    false
  end
end

class Class #:nodoc:
  def duplicable?
    false
  end
end

class Module #:nodoc:
  def duplicable?
    false
  end
end

# frozen_string_literal: true

##
# Simple clause: join elements with spaces
#
class Clause < Array
  def to_query
    join(" ")
  end

  def +(other)
    self.class.new(super)
  end

  ##
  # Return clause: join nodes with comma
  #
  class Return < Clause
    def to_query
      join(", ")
    end
  end

  ##
  # Match clause: join nodes with comma, and relationships between nodes with spaces:
  # [(n), (m)] => MATCH (n), (m)
  # [(n), -[r]->, (m)] => MATCH (n) -[r]-> (m)
  #
  class Match < Clause
    def to_query
      # Determine separators: if previous element ends with '>' or next element
      # starts with '-', use space as separator, otherwise use comma space
      separators = each_cons(2).map do |one, two|
        next " " if one.ends_with?(">") || two.starts_with?("-")

        ", "
      end

      # Zip query elements with separators and compact (because there are n - 1 separators)
      zip(separators).flatten.compact.join
    end
  end
end

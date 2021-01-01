require_relative 'common'

require 'delegate'

require 'rgl/adjacency'
require 'rgl/dijkstra'

class WeightedGraph < SimpleDelegator
  def self.delegate_with_weights(*method_names)
    method_names.each do |method_name|
      define_method method_name do |*args|
        __getobj__.send method_name, @edge_weights, *args
      end
    end
  end

  def initialize(reversed: false)
    super(RGL::DirectedAdjacencyGraph.new)
    @reversed = reversed
    @reverse = self.class.new(reversed: true) unless @reversed
    @edge_weights = {}
  end

  def add_vertices(*args)
    @reverse.add_vertices(*args) unless @reversed
    super
  end

  def add_weighted_edge(src, dst, weight=1)
    @reverse.add_weighted_edge(dst, src, weight) unless @reversed
    @edge_weights[[src, dst]] = weight
    add_edge(src, dst)
  end

  def weight_for(src, dst)
    @edge_weights[[src, dst]]
  end

  def reverse
    @reverse
  end

  delegate_with_weights :bellman_ford_shortest_paths,
    :dijkstra_shortest_paths,
    :dijkstra_shortest_path,
    :prim_minimum_spanning_tree
end

class Day7 < AdventDay
  MAIN_BAG_TYPE = 'shiny gold bag'.freeze
  def main
    rules_graph(input).
      reverse. # To get graph of being-contained-by
      dijkstra_shortest_paths(MAIN_BAG_TYPE). # Compute which bags are reachable
      reject { |dst, _path| dst == MAIN_BAG_TYPE}. # Remove tautological self-to-self case
      count { |_dst, path| path != nil } # Count reachable ones
  end

  def alternate
    graph = rules_graph(input)
    subtree_bag_cost(MAIN_BAG_TYPE, graph) - 1 # initial bag already shouldn't be counted in result
  end

  private

  def subtree_bag_cost(source, graph, current_cost = 1)
    neighbors = graph.adjacent_vertices(source)
    current_cost + neighbors.map do |neighbor|
      vertex_cost = graph.weight_for(source, neighbor)
      current_cost * subtree_bag_cost(neighbor, graph, vertex_cost)
    end.then { |cost| cost&.reduce(&:+) || 0 }
  end

  def rules_graph(edges)
    return @rules_graph if defined? @rules_graph
    @rules_graph = WeightedGraph.new

    vertices = edges.keys.flatten
    @rules_graph.add_vertices(*vertices)

    edges.each do |(src, dst), weight|
      @rules_graph.add_weighted_edge src, dst, weight
    end
    @rules_graph
  end

  def convert_data(data)
    super.map do |rule|
      src, *dst_rules = rule.scan(/(?:^|,| )(.*? bag)s?[,. ]/).flatten
      dst_rules.map do |dst_rule|
        weight, dst = dst_rule.scan(/(\d+) (.*)/).flatten
        [[src, dst], weight.to_i]
      end.to_h
    end.reduce(&:merge)
  end
end

p Day7.new.main
p Day7.new.alternate

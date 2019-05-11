import UIKit

public protocol Edge: CustomStringConvertible {
    var u: Int {get set} //index of the "from" vertex
    var v: Int {get set} //index of the "to" vertex
    var reversed: Edge {get}
}

protocol Graph: class, CustomStringConvertible {
    associatedtype VertexType: Equatable //'associatedtype' is being used to define types that adopters of Graph can configure
    //an 'associatedtype' gives a placeholder name to a type that is used
    //as part of the protocol.
    //The actual type to use for that associated type isn't specified until
    //the protocol is adopted
    associatedtype EdgeType: Edge
    //A protocol declares an associated type to refer to the elements a
    //certain protocol can handle without knowing what the actual type is
    var vertices: [VertexType] { get set } //this array can be an array of any type that adopts Equatable
    var edges: [[EdgeType]] { get set }
}

extension Graph {
    //How many vertices are in the graph?
    public var vertexCount: Int { return vertices.count }
    
    //How many edges are in the graph?
    public var edgeCount: Int { return edges.joined().count }
    
    /// Get a vertex by its index.
    ///
    /// - parameter index: The index of the vertex.
    /// - returns: The vertex at i.
    public func vertexAtIndex(_ index: Int) -> VertexType {
        return vertices[index]
    }
    
    /// Find the first occurence of a vertex if exists.
    ///
    /// - parameter vertex: The vertex you are looking for.
    /// - returns: The index of the vertex. Return nil if it can't find it
    public func indexOfVertex(_ vertex: VertexType) -> Int? {
        if let i = vertices.firstIndex(of: vertex) {
            return i
        }
        return nil
    }
    
    ///Find all the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index of the vertex to find the negihbors of.
    /// - returns: An array of the neighbor vertices.
    public func neighborsForIndex(_ index: Int) -> [VertexType] {
        return edges[index].map({
            self.vertices[$0.v]
        })
    }
    
    ///Find all of the neighbors of a given Vertex.
    ///
    /// - parameter vertex: The vertex to find the neighbors of.
    /// - returns: An optional array of the neigbor vertices.
    public func neighborsForVertex(_ vertex: VertexType) -> [VertexType]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    ///Find all the edges of a vertex at a given index.
    ///
    /// - parameter index: The index of the vertex to find the children of.
    /// - returns: An array of edges of a given index
    public func edgesForIndex(_ index: Int) -> [EdgeType] {
        return edges[index]
    }
    
    /// Find all of the edges of a given vertex
    ///
    /// - parameter vertex: The vertex to find the edges of.
    /// - returns: An optional array of the edges
    public func edgesForVertex(_ vertex: VertexType) -> [EdgeType]? {
        if let i = indexOfVertex(vertex){
            return edgesForIndex(i)
        }
        return nil
    }
    
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added
    /// - returns: The index where the vertex was added
    public func addVertex(_ v: VertexType) -> Int {
        vertices.append(v)
        edges.append([EdgeType]())
        return vertices.count - 1
    }
    
    /// Add an edge to the graph
    ///
    /// - parameter e: The edge to add.
    public func addEdge(_ e: EdgeType) {
        edges[e.u].append(e)
        edges[e.v].append(e.reversed as! EdgeType)
    }
}

open class UnweightedEdge: Edge {
    
    public var u: Int //"from" vertex
    public var v: Int //"to" vertex
    public var reversed: Edge {
        return UnweightedEdge(u: v, v: u)
    }
    
    public init (u: Int, v: Int){
        self.u = u
        self.v = v
    }
    
    //MARK: CustomStringConvertible
    public var description: String {
        return "\(u) <-> \(v)"
    }
}

open class UnweightedGraph<V: Equatable>: Graph {
    
    public var vertices: [V] = [V]()
    public var edges: [[UnweightedEdge]] = [[UnweightedEdge]]() //Adjacent lists
    
    public init() {}
    
    public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex´s index.
    /// - parameter to: The ending vertex's index.
    public func addEdge(from: Int, to: Int) {
        addEdge(UnweightedEdge(u: from, v: to))
    }
    
    /// This is a convenience method that adds an unweighted, undirected
    /// edge between the first occurrence of two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    public func addEdge(from: V, to: V) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to){
            addEdge(UnweightedEdge(u: u, v: v))
        }
    }
    
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
}

var cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])

cityGraph.addEdge(from: "Seattle", to: "Chicago")
cityGraph.addEdge(from: "Seattle", to: "San Francisco")
cityGraph.addEdge(from: "San Francisco", to: "Riverside")
cityGraph.addEdge(from: "San Francisco", to: "Los Angeles")
cityGraph.addEdge(from: "Los Angeles", to: "Riverside")
cityGraph.addEdge(from: "Los Angeles", to: "Phoenix")
cityGraph.addEdge(from: "Riverside", to: "Phoenix")
cityGraph.addEdge(from: "Riverside", to: "Chicago")
cityGraph.addEdge(from: "Phoenix", to: "Dallas")
cityGraph.addEdge(from: "Phoenix", to: "Houston")
cityGraph.addEdge(from: "Dallas", to: "Chicago")
cityGraph.addEdge(from: "Dallas", to: "Atlanta")
cityGraph.addEdge(from: "Dallas", to: "Houston")
cityGraph.addEdge(from: "Houston", to: "Atlanta")
cityGraph.addEdge(from: "Houston", to: "Miami")
cityGraph.addEdge(from: "Atlanta", to: "Chicago")
cityGraph.addEdge(from: "Atlanta", to: "Washington")
cityGraph.addEdge(from: "Atlanta", to: "Miami")
cityGraph.addEdge(from: "Miami", to: "Washington")
cityGraph.addEdge(from: "Chicago", to: "Detroit")
cityGraph.addEdge(from: "Detroit", to: "Boston")
cityGraph.addEdge(from: "Detroit", to: "Washington")
cityGraph.addEdge(from: "Detroit", to: "New York")
cityGraph.addEdge(from: "Boston", to: "New York")
cityGraph.addEdge(from: "New York", to: "Philadelphia")
cityGraph.addEdge(from: "Philadelphia", to: "Washington")

print(cityGraph)

//4.2 Finding the shortest path

public typealias Path = [Edge]

extension Graph {
    /// Prints a path in a readable format
    public func printPath(_ path: Path) {
        for edge in path {
            print("\(vertexAtIndex(edge.u)) > \(vertexAtIndex(edge.v))")
        }
    }
}


//4.2.2 Breadth-first search (BFS)
public class Queue<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool {
        return container.isEmpty
    }
    public func push(_ thing: T) {
        container.append(thing)
    }
    public func pop() -> T {
        return container.removeFirst()
    }
}

/// Takes a dictionary of edges to reach each node and returns an array of edges
/// that goes from `from` to `to`
public func pathDictToPath(from: Int, to: Int, pathDict: [Int:Edge]) -> Path {
    if pathDict.count == 0 {
        return []
    }
    var edgePath: Path = Path()
    var e: Edge = pathDict[to]!
    edgePath.append(e)
    while e.u != from {
        e = pathDict[e.u]!
        edgePath.append(e)
    }
    return Array(edgePath.reversed())
}

extension Graph {
    //returns a path to the goal vertex
    func bfs(initialVertex: VertexType, goalTestFn: (VertexType) -> Bool) -> Path? {
        guard let startIndex = indexOfVertex(initialVertex) else {return nil}
        //frontier is where we've yet to go
        let frontier: Queue<Int> = Queue<Int>()
        frontier.push(startIndex)
        //explored is where we've been
        var explored: Set<Int> = Set<Int>()
        explored.insert(startIndex)
        // how did we get to each vertex
        var pathDict: [Int:EdgeType] = [Int:EdgeType]()
        //keep going while there is more to explore
        while !frontier.isEmpty {
            let currentIndex = frontier.pop()
            let currentVertex = vertexAtIndex(currentIndex)
            //if we found the goal, we're done
            if goalTestFn(currentVertex) {
                return pathDictToPath(from: startIndex, to: currentIndex, pathDict: pathDict)
            }
            //check where we can go next and haven't explored
            for edge in edgesForIndex(currentIndex) where !explored.contains(edge.v){
                explored.insert(edge.v)
                frontier.push(edge.v)
                pathDict[edge.v] = edge
            }
        }
        return nil //never found the goal
    }
}

if let bostonToMiami = cityGraph.bfs(initialVertex: "Boston", goalTestFn: { $0 == "Miami" }) {
    cityGraph.printPath(bostonToMiami)
}

//4.3.1 Working with weights
public protocol Summable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension Float: Summable {}

open class WeightedEdge<W: Comparable & Summable>: Edge, Comparable {
    public var u: Int
    public var v: Int
    public let weight: W
    
    public var reversed: Edge {
        return WeightedEdge(u: v, v: u, weight: weight)
    }
    
    public init(u: Int, v: Int, weight: W){
        self.u = u
        self.v = v
        self.weight = weight
    }
    
    public var description: String {
        return "\(u) <\(weight) \(v)"
    }
    //MARK: Operator Overloads for Comparable
    static public func == <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.weight == rhs.weight
    }
    
    static public func < <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        // The < operator is only interested in looking at weights because Jarnik's algorithm
        //is interested in finding the smallest edge by weight
        return lhs.weight < rhs.weight
    }
}

open class WeightedGraph<V: Equatable & Hashable, W: Comparable & Summable>: Graph {
    var vertices: [V] = [V]()
    var edges: [[WeightedEdge<W>]] = [[WeightedEdge<W>]]() //adjacency lists
    
    public init(){}
    
    public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    /// Find all of the neighbors of a vertex at a given index
    ///
    /// - parameter index: The index for the vertex to find the neighbors of
    /// - returns: An array of tuples including the vertices as the first element
    /// and the weights as the second element
    public func neighborsForIndexWithWeights(_ index: Int) -> [(V,W)] {
        var distanceTuples: [(V,W)] = [(V,W)]()
        for edge in edges[index] {
            distanceTuples += [(vertices[edge.v],edge.weight)]
        }
        return distanceTuples
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter weight: The Weight of the edge to add
    public func addEdge(from: Int, to: Int, weight: W) {
        addEdge(WeightedEdge<W>(u: from, v: to, weight: weight))
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurrence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: V, to: V, weight: W) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(WeightedEdge<W>(u: u, v: v, weight:weight))
            }
        }
    }
    
    public var description: String {
        var d: String = " "
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))"
        }
        return d
    }
}

let cityGraph2: WeightedGraph<String,
    Int> = WeightedGraph<String, Int>(vertices:
        ["Seattle", "San Francisco", "Los Angeles", "Riverside",
        "Phoenix", "Chicago", "Boston", "New York", "Atlanta",
        "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])

cityGraph2.addEdge(from: "Seattle", to: "Chicago", weight: 1737)
cityGraph2.addEdge(from: "Seattle", to: "San Francisco", weight: 678)
cityGraph2.addEdge(from: "San Francisco", to: "Riverside", weight: 386)
cityGraph2.addEdge(from: "San Francisco", to: "Los Angeles", weight: 348)
cityGraph2.addEdge(from: "Los Angeles", to: "Riverside", weight: 50)
cityGraph2.addEdge(from: "Los Angeles", to: "Phoenix", weight: 357)
cityGraph2.addEdge(from: "Riverside", to: "Phoenix", weight: 307)
cityGraph2.addEdge(from: "Riverside", to: "Chicago", weight: 1704)
cityGraph2.addEdge(from: "Phoenix", to: "Dallas", weight: 887)
cityGraph2.addEdge(from: "Phoenix", to: "Houston", weight: 1015)
cityGraph2.addEdge(from: "Dallas", to: "Chicago", weight: 805)
cityGraph2.addEdge(from: "Dallas", to: "Atlanta", weight: 721)
cityGraph2.addEdge(from: "Dallas", to: "Houston", weight: 225)
cityGraph2.addEdge(from: "Houston", to: "Atlanta", weight: 702)
cityGraph2.addEdge(from: "Houston", to: "Miami", weight: 968)
cityGraph2.addEdge(from: "Atlanta", to: "Chicago", weight: 588)
cityGraph2.addEdge(from: "Atlanta", to: "Washington", weight: 543)
cityGraph2.addEdge(from: "Atlanta", to: "Miami", weight: 604)
cityGraph2.addEdge(from: "Miami", to: "Washington", weight: 923)
cityGraph2.addEdge(from: "Chicago", to: "Detroit", weight: 238)
cityGraph2.addEdge(from: "Detroit", to: "Boston", weight: 613)
cityGraph2.addEdge(from: "Detroit", to: "Washington", weight: 396)
cityGraph2.addEdge(from: "Detroit", to: "New York", weight: 482)
cityGraph2.addEdge(from: "Boston", to: "New York", weight: 190)
cityGraph2.addEdge(from: "New York", to: "Philadelphia", weight: 81)
cityGraph2.addEdge(from: "Philadelphia", to: "Washington", weight: 123)

print("\n\(cityGraph2)")

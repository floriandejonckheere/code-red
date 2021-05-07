import { Controller } from "stimulus";

import settings from "../graph/settings"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    super.connect()

    fetch("/tasks.json")
      .then(response => response.json())
      .then(json => {
        // Create the input graph
        var g = new dagreD3.graphlib.Graph()
          .setGraph({})
          .setDefaultEdgeLabel(function() { return {}; });

        // Create the SVG label to pass in
        // Must create in SVG namespace
        // http://stackoverflow.com/questions/7547117/add-a-new-line-in-svg-bug-cannot-see-the-line
        // This mimics the same way string labels get added in Dagre-D3
        var svg_label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        var tspan = document.createElementNS('http://www.w3.org/2000/svg','tspan');
        tspan.setAttributeNS('http://www.w3.org/XML/1998/namespace', 'xml:space', 'preserve');
        tspan.setAttribute('dy', '1em');
        tspan.setAttribute('x', '1');
        var link = document.createElementNS('http://www.w3.org/2000/svg', 'a');
        link.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', 'http://google.com/');
        link.setAttribute('target', '_blank');
        link.textContent = 'IE Capable link';
        tspan.appendChild(link);
        svg_label.appendChild(tspan);

        console.log(svg_label);

        // Here we're setting nodeclass, which is used by our custom drawNodes function
        // below.
        g.setNode(0,  { label: svg_label,       labelType: 'svg', class: "rounded-sm" });
        g.setNode(1,  { label: "S",         class: "rounded-sm" });
        g.setNode(2,  { label: "NP",        class: "type-NP" });
        g.setNode(3,  { label: "DT",        class: "type-DT" });
        g.setNode(4,  { label: "This",      class: "type-TK" });
        g.setNode(5,  { label: "VP",        class: "type-VP" });
        g.setNode(6,  { label: "VBZ",       class: "type-VBZ" });
        g.setNode(7,  { label: "is",        class: "type-TK" });
        g.setNode(8,  { label: "NP",        class: "type-NP" });
        g.setNode(9,  { label: "DT",        class: "type-DT" });
        g.setNode(10, { label: "an",        class: "type-TK" });
        g.setNode(11, { label: "NN",        class: "type-NN" });
        g.setNode(12, { label: "example",   class: "type-TK" });
        g.setNode(13, { label: ".",         class: "type-." });
        g.setNode(14, { label: "sentence",  class: "type-TK" });

        g.nodes().forEach(function(v) {
          var node = g.node(v);

          // Round the corners of the nodes
          node.rx = node.ry = 4;
        });

        // Set up edges, no special attributes.
        g.setEdge(3, 4);
        g.setEdge(2, 3);
        g.setEdge(1, 2);
        g.setEdge(6, 7);
        g.setEdge(5, 6);
        g.setEdge(9, 10);
        g.setEdge(8, 9);
        g.setEdge(11,12);
        g.setEdge(8, 11);
        g.setEdge(5, 8);
        g.setEdge(1, 5);
        g.setEdge(13,14);
        g.setEdge(1, 13);
        g.setEdge(0, 1)

        // Create the renderer
        var render = new dagreD3.render();

        // Set up an SVG group so that we can translate the final graph.
        var svg = d3.select(this.containerTarget),
          svgGroup = svg.append("g");

        // Run the renderer. This is what draws the final graph.
        render(d3.select("svg g"), g);

        // Center the graph
        // var xCenterOffset = (svg.attr("width") - g.graph().width) / 2;
        // svgGroup.attr("transform", "translate(" + xCenterOffset + ", 20)");
        svg.attr("height", g.graph().height);
        svg.attr("width", g.graph().width);
      })
  }
}

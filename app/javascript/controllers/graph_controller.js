import { Controller } from 'stimulus'

import settings from "../graph/settings"

export default class extends Controller {
  static targets = ['container']

  connect() {
    super.connect()

    const svg = d3.select(this.containerTarget)

    const cola = window.cola.d3adaptor(d3)
      .linkDistance(200)
      .avoidOverlaps(true)
      .handleDisconnected(true)
      .convergenceThreshold(1e-9)
      .size([
        svg.node().getBoundingClientRect().width,
        svg.node().getBoundingClientRect().height,
      ])

    fetch('/tasks.json')
      .then(response => response.json())
      .then(graph => {
        cola
          .nodes(graph.nodes)
          .links(graph.edges)
          .start()

        const link = svg
          .selectAll('.link')
          .data(graph.edges)
          .enter()
          .append('line')
          .attr('class', 'link')

        const node = svg
          .selectAll('.node')
          .data(graph.nodes)
          .enter()
          .append('rect')
          .attr('class', 'node')
          .attr('width', settings.node.width)
          .attr('height', settings.node.height)
          .attr('rx', 4)
          .attr('ry', 4)
          .style('fill', d => 'white')
          .call(cola.drag)

        const label = svg
          .selectAll('.label')
          .data(graph.nodes)
          .enter()
          .append('text')
          .attr('class', 'label')
          .text(d => d.label)
          .call(cola.drag)

        node
          .append('title')
          .text(d => d.label)

        cola.on('tick', () => {
          link
            .attr('x1', d => d.source.x)
            .attr('y1', d => d.source.y)
            .attr('x2', d => d.target.x)
            .attr('y2', d => d.target.y)

          node
            .attr('x', d => (d.x - settings.node.width / 2))
            .attr('y', d => (d.y - settings.node.height / 2))

          label
            .attr('x', d => (d.x))
            .attr('y', function (d) {
              var h = this.getBBox().height
              return d.y + h / 4
            })
        })
      })
  }
}

import { Controller } from 'stimulus'

import settings from "../graph/settings"

export default class extends Controller {
  static targets = ['container']

  connect() {
    super.connect()

    this.svg = d3.select(this.containerTarget)

    this.cola = window.cola.d3adaptor(d3)
      .linkDistance(settings.edge.length)
      .avoidOverlaps(true)
      .handleDisconnected(false)
      .convergenceThreshold(1e-9)
      .size([
        this.svg.node().getBoundingClientRect().width,
        this.svg.node().getBoundingClientRect().height,
      ])

    const zoom = d3
      .zoom()
      .scaleExtent([settings.zoom.min, settings.zoom.max])
      .on('zoom', () => {
        this.container
          .attr('transform', d3.event.transform)
      })

    this.svg
      .append('rect')
      .attr('class', 'background')
      .attr('width', '100%')
      .attr('height', '100%')
      .call(zoom)

    this.container = this.svg
      .append('g')
      .attr('transform', 'translate(0, 0)')

    fetch('/tasks.json')
      .then(response => response.json())
      .then(graph => {
        this.cola
          .nodes(graph.nodes)
          .links(graph.edges)
          // .constraints(graph.constraints)
          .groups(graph.groups)
          .start()

        const edge = this.container
          .selectAll('.link')
          .data(graph.edges)
          .enter()
          .append('line')
          .attr('class', 'link')

        const anchor = this.container
          .selectAll('.anchor')
          .data(graph.nodes)
          .enter()
          .append('a')
          .attr('class', 'anchor')
          .attr('data-action', 'click->task-modal#open')
          .attr('data-turbo-frame', 'task')
          .attr('href', d => `/tasks/${d.id}/edit`)
          .attr('width', settings.node.width)
          .attr('height', settings.node.height)
          .call(this.cola.drag)

        const node = anchor
          .append('rect')
          .attr('class', 'node')
          .attr('width', settings.node.width)
          .attr('height', settings.node.height)
          .attr('rx', settings.node.radius)
          .attr('ry', settings.node.radius)
          .call(this.cola.drag)

        node
          .append('title')
          .text(d => d.label)

        const label = anchor
          .append('text')
          .attr('class', 'label')
          .text(d => d.label)
          .call(this.cola.drag)

        const icon = anchor
          .append('svg')
          .attr('width', 16)
          .attr('height', 16)
          .attr('viewBox', `0 0 24 24`)
          .attr('preserveAspectRatio', 'xMinYMin')
          .attr('class', d => `icon text-${d.color}`)
          .html(d => d.icon)
          .call(this.cola.drag)

        const type = anchor
          .append('text')
          .attr('class', d => `type text-${d.color}`)
          .text(d => d.type)
          .call(this.cola.drag)

        this.cola.on('tick', () => {
          edge
            .attr('x1', d => d.source.x)
            .attr('y1', d => d.source.y)
            .attr('x2', d => d.target.x)
            .attr('y2', d => d.target.y)

          node
            .attr('x', d => (d.x - settings.node.width / 2))
            .attr('y', d => (d.y - settings.node.height / 2))

          label
            .attr('x', d => (d.x - settings.node.width / 2) + settings.node.padding)
            .attr('y', d => (d.y - settings.node.height / 2) + settings.node.padding + 16)

          icon
            .attr('x', d => (d.x - settings.node.width / 2) + settings.node.padding)
            .attr('y', d => (d.y + settings.node.height / 2) - 16 - settings.node.padding)

          type
            .attr('x', d => (d.x - settings.node.width / 2) + 20 + settings.node.padding)
            .attr('y', d => (d.y + settings.node.height / 2) - 14)
        })
      })
  }
}

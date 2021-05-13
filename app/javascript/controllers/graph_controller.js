import { Controller } from 'stimulus'

import settings from "../graph/settings"

export default class extends Controller {
  static targets = ['container']

  static values = {
    projectId: String,
  }

  connect() {
    super.connect()

    this.svg = d3.select(this.containerTarget)

    // Arrow markers
    this.svg
      .append('svg:defs')
      .append('svg:marker')
      .attr('id', 'end-arrow')
      .attr('viewBox', '0 -5 10 10')
      .attr('refX', 5)
      .attr('markerWidth', 5)
      .attr('markerHeight', 5)
      .attr('orient', 'auto')
      .append('svg:path')
      .attr('d', 'M0,-5L10,0L0,5L2,0')
      .attr('stroke-width', '0px')
      .attr('fill', '#999')

    this.cola = window.cola.d3adaptor(d3)
      .linkDistance(settings.edge.length)
      .avoidOverlaps(true)
      .handleDisconnected(true)
      .convergenceThreshold(1e-3)
      .size([
        this.svg.node().getBoundingClientRect().width,
        this.svg.node().getBoundingClientRect().height,
      ])

    this.zoom = d3
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
      .call(this.zoom)

    this.container = this.svg
      .append('g')
      .attr('transform', 'translate(0, 0)')

    this.render()
  }

  reset() {
    setTimeout(() => {
      this.container
        .selectAll('*')
        .remove()

      this.render()
    }, 100)
  }

  render() {
    fetch(`/projects/${this.projectIdValue}/tasks.json`)
      .then(response => response.json())
      .then(graph => {
        console.log('rendered')

        console.log(this.cola._nodes)

        // Inject height/width for bounding boxes
        graph.nodes = graph.nodes
          .map(node => { return { ...node, width: (settings.node.width + settings.node.padding), height: (settings.node.height + settings.node.padding) } })

        this.cola
          .linkDistance(settings.edge.length)
          .nodes(graph.nodes)
          .links(graph.edges)
          // .constraints(graph.constraints)
          .groups(graph.groups)
          .start(settings.iterations.layout, settings.iterations.structural, settings.iterations.all)

        setTimeout(() => { this.cola.stop() }, settings.iterations.timeout)

        const edge = this.container
          .selectAll('.link')
          .data(graph.edges)
          .enter()
          .append('line')
          .attr('class', 'link')

        const edgeLabel = this.container
          .selectAll('.link-label')
          .data(graph.edges)
          .enter()
          .append('text')
          .attr('class', 'link-label')
          .text(d => d.label)
          .call(this.cola.drag)

        const anchor = this.container
          .selectAll('.anchor')
          .data(graph.nodes)
          .enter()
          .append('a')
          .attr('class', 'anchor')
          .attr('data-action', 'click->task-modal#open')
          .attr('data-turbo-frame', 'task')
          .attr('href', d => `/projects/${this.projectIdValue}/tasks/${d.id}/edit`)
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
          .append('foreignObject')
          .attr('class', d => `label text-${d.status}ZZ`)
          .attr('width', settings.node.width - (2 * settings.node.padding))
          .attr('height', 20)
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
          node
            .attr('x', d => (d.x - settings.node.width / 2))
            .attr('y', d => (d.y - settings.node.height / 2))
            .each(d => d.innerBounds = d.bounds.inflate(-5))

          edge
            .each(d => d.route = window.cola.makeEdgeBetween(d.source.innerBounds, d.target.innerBounds, 5))

          edge
            .attr('x1', d => d.route.sourceIntersection.x)
            .attr('y1', d => d.route.sourceIntersection.y)
            .attr('x2', d => d.route.arrowStart.x)
            .attr('y2', d => d.route.arrowStart.y)

          edgeLabel
            .attr('transform', d => {
              // Calculate angle of edge
              const p1 = d.route.sourceIntersection
              const p2 = d.route.targetIntersection

              let rad = Math.atan2(p2.y - p1.y, p2.x - p1.x)
              let deg = rad * 180 / Math.PI

              // Calculate middle of edge
              let x = (p1.x + p2.x) / 2
              let y = (p1.y + p2.y) / 2

              // Flip labels if upside down
              if ((deg > 90 && deg < 270) || (deg < -90 && deg > -270)) {
                rad -= Math.PI
                deg -= 180
              }

              // Float labels above edge
              x += settings.edge.margin * Math.sin(rad)
              y -= settings.edge.margin * Math.cos(rad)

              return `translate(${x}, ${y}) rotate(${deg})`
            })

          label
            .attr('x', d => (d.x - settings.node.width / 2) + settings.node.padding)
            .attr('y', d => (d.y - settings.node.height / 2) + settings.node.padding)

          icon
            .attr('x', d => (d.x - settings.node.width / 2) + settings.node.padding)
            .attr('y', d => (d.y + settings.node.height / 2) - 16 - settings.node.padding)

          type
            .attr('x', d => (d.x - settings.node.width / 2) + 20 + settings.node.padding)
            .attr('y', d => (d.y + settings.node.height / 2) - 14)
        })
      })
  }

  zoomIn(e) {
    e.preventDefault()

    this.svg
      .transition()
      .duration(500)
      .call(this.zoom.scaleBy, settings.zoom.step)
  }

  zoomOut(e) {
    e.preventDefault()

    this.svg
      .transition()
      .duration(500)
      .call(this.zoom.scaleBy, -1 * settings.zoom.step)
  }

  zoomReset(e) {
    e.preventDefault()

    this.svg
      .transition()
      .duration(750)
      .call(this.zoom.transform, d3.zoomIdentity)
  }
}

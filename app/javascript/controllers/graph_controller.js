import { Controller } from "stimulus";

import settings from "../graph/settings"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    super.connect()

    fetch("/tasks.json")
      .then(response => response.json())
      .then(json => {
        const s = new sigma({
          graph: json,
          renderer: {
            container: this.containerTarget,
            type: "svg",
          },
          settings: settings,
        })

        s.startForceAtlas2({
          linLogMode: false, // switch ForceAtlas' model from lin-lin to lin-log (tribute to Andreas Noack). Makes clusters more tight.
          outboundAttractionDistribution: false,
          adjustSizes: false,
          edgeWeightInfluence: 0, // how much influence you give to the edges weight. 0 is "no influence" and 1 is "normal".
          scalingRatio: 1, // how much repulsion you want. More makes a more sparse graph.
          strongGravityMode: false,
          gravity: 1, // attracts nodes to the center. Prevents islands from drifting away.
          barnesHutOptimize: false, // should we use the algorithm's Barnes-Hut to improve repulsion's scalability (`O(n²)` to `O(nlog(n))`)? This is useful for large graph but harmful to small ones.
          barnesHutTheta: 0.5,
          slowDown: 1,
          startingIterations: 10, // number of iterations to be run before the first render.
          iterationsPerRender: 0, // number of iterations to be run before each render.
      });

        setTimeout(() => s.stopForceAtlas2(), 2000)
      })
  }
}

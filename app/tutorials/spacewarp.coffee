Step = zootorial.Step

module.exports = new zootorial.Tutorial
  id: "spacewarp_dashboard_tutorial"
  firstStep: 'welcome'
  steps:
    welcome: new Step
              header: 'Welcome'
              details: "Let's learn about the SpaceWarps Dashboard."
              nextButton: 'Start Tutorial'
              next: 'viewer'
    viewer: new Step
              header: "Space Warps Viewer"
              details: "The Space Warps viewer is used to examine raw astronomical images. Right of the image are various tools to expose different features in the image."
              next: 'alpha'
    alpha: new Step
              header: "Parameters (alpha)"
              details: "Adjust this slider to raise or lower the overall brightness of the image."
              attachment: 'right center input[name="alpha"] -0.2 0.30'
              className: 'arrow-right'
              next: 'Q'
    Q: new Step
              header: "Parameters (Q)"
              details: "Adjust this slider to raise or lower only the saturated objects such as bright stars."
              attachment: 'right center input[name="Q"] -0.2 0.30'
              className: 'arrow-right'
              next: 'rgb'
    rgb: new Step
              header: "Parameters (RGB)"
              details: "Adjust these sliders to adjust the red, green, and blue channels."
              attachment: 'right center input.green -0.2 0.30'
              className: 'arrow-right'


import Vapor

let slackToken = "xoxb-304979555265-YxjCiaAccThz97yDXAAFBx9l"


let drop = try Droplet()

let config = Catoci.Configuration(slackToken: slackToken)
let catoci = Catoci(config: config, droplet: drop)

try catoci.start()

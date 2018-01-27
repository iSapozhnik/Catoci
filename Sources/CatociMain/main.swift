
import Vapor

let slackToken = "xoxb-304979555265-bEkdVs0UhPAMK1FMO5R3tNpC"

let drop = try Droplet()

let config = Catoci.Configuration(slackToken: slackToken)
let catoci = Catoci(config: config, droplet: drop)

try catoci.start()

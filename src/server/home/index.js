import { connectivityController } from '~/src/server/home/controller.js'
import { makeConnectionController } from '~/src/server/home/connections.js'

/**
 * Sets up the routes used in the /home page.
 * These routes are registered in src/server/router.js.
 */
const home = {
  plugin: {
    name: 'connectivity',
    register: async (server) => {
      server.route([
        {
          method: 'GET',
          path: '/',
          ...connectivityController
        },
        {
          method: 'GET',
          path: '/connections',
          ...makeConnectionController
        }
      ])
    }
  }
}

export { home }

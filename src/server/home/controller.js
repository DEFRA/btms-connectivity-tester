/**
 * A GDS styled example about page controller.
 * Provided as an example, remove or modify as required.
 */
import { config } from '~/src/config/index.js'

const connectivityController = {
  handler: (request, h) => {
    return h.view('home/index', {
      pageTitle: 'Connectivity',
      heading: 'Connectivity',
      breadcrumbs: [
        {
          text: 'Home',
          href: '/'
        }
      ],
      urlList: config.get('urlList').map((e) => {
        return {
          text: e.text,
          value: e.value,
          selected: e.selected
        }
      })
    })
  }
}

export { connectivityController }

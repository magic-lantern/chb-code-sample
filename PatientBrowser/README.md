# SMART App Gallery Patient Browser

Frontend code sample (est. time 2 hours): Create a prototype of a web based tool to enable app developers to browse the SMART sample patient set to find a list of appropriate patient ids to use when demonstrating their app. This tool should run entirely on the front end and should use the open FHIR endpoint at https://sb-fhir-dstu2.smarthealthit.org/api/smartdstu2/open to retrieve the patient lists and details (I’d suggest using the Patient resource query and the “$everything” operation). Any frontend javascript framework (or none) is acceptable. Functionality that is designed but not implemented can be indicated through failing unit tests or placeholder comments in the code.

Technologies employed:
* [EmberJS](http://emberjs.com/)
* [Bootstrap](http://getbootstrap.com/)
* [Font Awesome](https://fortawesome.github.io/Font-Awesome/)
* [FHIR](https://www.hl7.org/fhir/)
* [SMART on FHIR](http://smarthealthit.org/)

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).

### Code Generators

Make use of the many generators for code, try `ember help generate` for more details

### Running Tests

* `ember test`
* `ember test --server`

### Building

* `ember build` (development)
* `ember build --environment production` (production)

### Deploying

TBD

## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)


## License
For code written by [magic-lantern](https://github.com/magic-lantern), see the [LICENSE](LICENSE) file for license rights and limitations (Apache License, Version 2.0).
Code from other parties may have different licensing terms.

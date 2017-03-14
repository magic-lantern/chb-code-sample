# SMART App Gallery Patient Browser

Frontend code sample (est. time 2 hours): Create a prototype of a web based tool to enable app developers to browse the SMART sample patient set to find a list of appropriate patient ids to use when demonstrating their app. This tool should run entirely on the front end and should use the open FHIR endpoint at https://sb-fhir-dstu2.smarthealthit.org/api/smartdstu2/open to retrieve the patient lists and details (I’d suggest using the Patient resource query and the “$everything” operation). Any frontend javascript framework (or none) is acceptable. Functionality that is designed but not implemented can be indicated through failing unit tests or placeholder comments in the code.

**Features**
* Patient Browser is modeled after a Primary Care Provider summary screen.
* Patient List is sorted by last name
* Patients can be selected for inclusion in list. Variable selectedPatients keeps track of selected patients.
* When user clicks patient name from list, show patient info in main screen

**Technologies employed:**
* [EmberJS](http://emberjs.com/)
* [Bootstrap](http://getbootstrap.com/)
* [Font Awesome](https://fortawesome.github.io/Font-Awesome/)
* [FHIR](https://www.hl7.org/fhir/)

## TODOs
1. Need to sort medications, encounters, labs, etc. by date
1. Need to view other resources returned by FHIR. Currently only showing a limited number of these:
 * Condition
 * MedicationOrder
 * AllergyIntolerance
 * Encounter
1. Need method to view all items for each resources returned by FHIR. Currently only showing 5 items.
1. Variable selectedPatients is maintained, but not exportable nor passed on to other processes.
1. Ability to page through patient list - or use server side search/count limit. Right now all data is returned and displayed.
1. Need error handling for subsequent patient $everything request
1. Need to retrieve observations for standard vitals - heart rate, blood pressure, weight, etc.
1. Need to write unit tests.

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

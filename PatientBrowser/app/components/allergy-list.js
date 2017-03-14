import Ember from 'ember';

export default Ember.Component.extend({
  highlight_color: null,
  allergies: null,
  index: 0,
  severity: null,
  manifestation: null,
  category: null,
  date: null,
  substance: null,
  text: null,
  shouldShow: false,
  onChange: function () {
    if(!Ember.isEmpty(this.allergies) && !Ember.isEmpty(this.allergies[this.index])){
      for (let i in this.allergies[this.index]) {
        this.set(i, this.allergies[this.index][i]);
      }
      this.set('substance', this.allergies[this.index].substance.capitalize());
      this.set('shouldShow', true);
    }
    else {
      this.set('category', null);
      this.set('substance', null);
      this.set('severity', null);
      this.set('date', null);
      this.set('shouldShow', false);
    }
  }.observes('allergies'),
});

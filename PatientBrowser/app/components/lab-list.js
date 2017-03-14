import Ember from 'ember';

export default Ember.Component.extend({
  highlight_color: null,
  labs: null,
  index: 0,
  shouldShow: false,
  display: null,
  value: null,
  unit: null,
  date: null,
  onChange: function () {
    if(!Ember.isEmpty(this.labs) && !Ember.isEmpty(this.labs[this.index])){
      for (let i in this.labs[this.index]) {
        this.set(i, this.labs[this.index][i]);
      }
      this.set('display', this.labs[this.index].display.capitalize());
      this.set('shouldShow', true);
    }
    else {
      this.set('display', null);
      this.set('value', null);
      this.set('unit', null);
      this.set('date', null);
      this.set('shouldShow', false);
    }
  }.observes('labs'),
});

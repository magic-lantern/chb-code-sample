import Ember from 'ember';

export default Ember.Component.extend({
  highlight_color: null,
  meds: null,
  index: 0,
  display: null,
  date: null,
  shouldShow: false,
  onChange: function () {
    if(!Ember.isEmpty(this.meds) && !Ember.isEmpty(this.meds[this.index])){
      this.set('display', this.meds[this.index].display.capitalize());
      this.set('date', this.meds[this.index].date);
      this.set('shouldShow', true);
    }
    else {
      this.set('display', null);
      this.set('date', null);
      this.set('shouldShow', false);
    }
  }.observes('meds')
});

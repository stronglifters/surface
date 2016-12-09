var Exercise = React.createClass({
  render: function() {
    var setNodes = this.props.exercise.sets.map(function(set) {
      var model = new Stronglifters.Set(set);
      return (
        <Set key={set.id} model={model} />
      );
    });
    return (
      <li className="accordion-item" data-accordion-item>
        <a href="#" className="accordion-title">{this.props.exercise.name}</a>
        <div className="accordion-content" data-tab-content>
          {setNodes}
        </div>
      </li>
    );
  }
});
